import 'package:flutter/material.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/pages/OrderProcessView.dart';
import 'package:mobileapp/pages/ProductView.dart';
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
    cartItemsStream = cartService.getCartItems();
    cartItemsStream.listen((items) {
      if (mounted) {
        setState(() {
          cartItems = items;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeFromCart(String id) {
    cartService.removeCartItem(id);
    _showSnackBar('Item removed from cart');
  }

  void _reduceQuantity(CartItem item) {
    if (item.quantity > 1) {
      cartService.updateCartItemQuantity(item.id, item.quantity - 1);
      _showSnackBar('Quantity reduced');
    } else {
      _removeFromCart(item.id); // If quantity is 1, remove the item
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 141),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      item.images.isNotEmpty &&
                              Uri.tryParse(item.images[0])?.isAbsolute == true
                          ? item.images[0]
                          : 'https://via.placeholder.com/150', // Fallback image
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        // Navigate to ProductView page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductView(
                                product: Product(
                                    id: item.id,
                                    name: item.name,
                                    description: item.description,
                                    price: item.price,
                                    stock: item.stock,
                                    images: item.images)),
                          ),
                        );
                      },
                      child: Text(
                        item.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                    ),
                    subtitle: Text(
                      'Price: \$${item.price.toStringAsFixed(2)}\nQuantity: ${item.quantity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: const Color.fromARGB(255, 58, 183, 141),
                          onPressed: () {
                            cartService.updateCartItemQuantity(
                                item.id, item.quantity + 1);
                            _showSnackBar('Quantity increased');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                          onPressed: () => _reduceQuantity(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever),
                          color: const Color.fromARGB(255, 58, 183, 141),
                          onPressed: () => _removeFromCart(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black26,
                  offset: Offset(0, -1),
                )
              ],
            ),
            child: Text(
              'Total: \$${cartItems.fold<double>(0.0, (total, item) => total + item.totalPrice).toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (cartItems.isEmpty) {
                _showSnackBar('Your cart is empty. Add items to proceed.');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderProcessView(cartItems: cartItems),
                  ),
                );
              }
            },
            child: const Text('Complete Shopping'),
          ),
        ],
      ),
    );
  }
}
