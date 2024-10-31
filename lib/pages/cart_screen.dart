import 'package:flutter/material.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/services/cartService.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();
  List<CartItem> cartItems = [];

  late Stream<List<CartItem>> cartItemsStream;

  @override
  void initState() {
    super.initState();
    cartItemsStream = cartService.getCartItems(); // Initialize the stream
    cartItemsStream.listen((items) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          cartItems = items;
        });
      }
    });
  }

  @override
  void dispose() {
    // Perform any necessary cleanup
    // Currently, there are no specific streams to cancel in CartService, but you could add a cleanup function there if needed.
    super.dispose();
  }

  void _removeFromCart(String id) {
    cartService.removeCartItem(id);
    // Optionally, you could also remove the item from cartItems immediately if needed
    // setState(() {
    //   cartItems.removeWhere((item) => item.id == id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Price: \$${item.price}, Quantity: ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () => _removeFromCart(item.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total: \$${cartItems.fold<double>(0.0, (total, item) => total + item.totalPrice)}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
