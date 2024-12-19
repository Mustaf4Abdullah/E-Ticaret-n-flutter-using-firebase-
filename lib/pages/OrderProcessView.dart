import 'package:flutter/material.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/models/Addresses.dart';
import 'package:mobileapp/models/Order.dart';
import 'package:mobileapp/models/OrderItem.dart';
import 'package:mobileapp/pages/home_customer_screen.dart';
import 'package:mobileapp/services/OrderService.dart';
import 'package:mobileapp/services/AddressService.dart';
import 'package:mobileapp/services/cartService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderProcessView extends StatefulWidget {
  final List<CartItem> cartItems;

  const OrderProcessView({Key? key, required this.cartItems}) : super(key: key);

  @override
  _OrderProcessViewState createState() => _OrderProcessViewState();
}

class _OrderProcessViewState extends State<OrderProcessView> {
  final AddressService _addressService = AddressService();
  final OrderService _orderService = OrderService();
  final CartService _cartService = CartService();

  List<Addresses> _addresses = [];
  String? _selectedAddressId;
  String _paymentMethod = 'Credit Card'; // Default payment method

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final addresses = await _addressService.getAddressesByUser(userId);
      setState(() {
        _addresses = addresses;
      });
    }
  }

  void _confirmOrder() async {
    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must select an address to continue.')),
      );
      return;
    }

    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final orderDate = DateTime.now();

    // Map cart items to order items
    final orderItems = widget.cartItems
        .map((cartItem) => OrderItem(
              productId: cartItem.productId,
              name: cartItem.name,
              price: cartItem.price,
              quantity: cartItem.quantity,
            ))
        .toList();

    final order = Order(
      orderId: orderId,
      userId: userId,
      orderDate: orderDate,
      items: orderItems,
    );

    try {
      await _orderService.createOrder(order);
      // After creating the order, remove the items from the cart
      for (var cartItem in widget.cartItems) {
        _cartService.removeCartItem(cartItem.id);
      }

      // Redirect to home after confirming the order
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeCustomerScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Order'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 141),
      ),
      body: _addresses.isEmpty
          ? const Center(
              child: Text('You must add an address before continuing.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cart Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = widget.cartItems[index];
                        return ListTile(
                          title: Text(cartItem.name),
                          subtitle: Text(
                              'Price: \$${cartItem.price} x ${cartItem.quantity}'),
                          trailing: Text(
                              '\$${cartItem.totalPrice.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    hint: const Text('Select an address'),
                    value: _selectedAddressId,
                    onChanged: (value) {
                      setState(() {
                        _selectedAddressId = value;
                      });
                    },
                    items: _addresses
                        .map((address) => DropdownMenuItem<String>(
                              value: address.id,
                              child: Text(address.fullAddress),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Credit Card',
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      const Text('Credit Card'),
                      Radio<String>(
                        value: 'Cash on Delivery',
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      const Text('Cash on Delivery'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_paymentMethod == 'Credit Card') ...[
                    const Text(
                      'Enter Card Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: _confirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 58, 183, 141),
                    ),
                    child: const Text('Confirm Order'),
                  ),
                ],
              ),
            ),
    );
  }
}
