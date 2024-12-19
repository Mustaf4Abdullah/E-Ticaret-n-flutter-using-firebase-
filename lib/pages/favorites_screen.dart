import 'package:flutter/material.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/pages/ProductView.dart';
import 'package:mobileapp/services/favoriteService.dart';
import 'package:mobileapp/auth.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService favoriteService = FavoriteService();
  List<Map<String, dynamic>> favoriteItems = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  void dispose() {
    favoriteService.dispose(); // Dispose of active streams
    super.dispose();
  }

  Future<void> loadFavorites() async {
    userId = await Auth().getCurrentUserId();
    favoriteService.getFavorites().listen((items) async {
      List<Map<String, dynamic>> updatedFavorites = [];
      for (FavoriteItem item in items) {
        Product? product = await favoriteService.getProductById(item.productId);
        if (product != null) {
          updatedFavorites.add({
            'favoriteId': item.productId,
            'productName': product.name,
            'description': product.description,
            'price': product.price,
            'stock': product.stock,
            'productImage': product.images.isNotEmpty
                ? product.images
                : [
                    'https://via.placeholder.com/150'
                  ], // Fallback image as a list
            // Fallback image
          });
        }
      }
      if (mounted) {
        setState(() {
          favoriteItems = updatedFavorites;
        });
      }
    });
  }

  void _removeFromFavorites(String productId) {
    favoriteService.removeFavorite(productId);
    setState(() {
      favoriteItems.removeWhere((item) => item['favoriteId'] == productId);
    });
    _showSnackBar('Item removed from favorites');
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
        title: const Text('Favorites'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 141),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  elevation: 3,
                  child: ListTile(
                    leading: Image.network(
                      Uri.tryParse(item['productImage'][0])?.isAbsolute == true
                          ? item['productImage'][0]
                          : 'https://via.placeholder.com/150',
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
                                    id: item['favoriteId'],
                                    name: item['productName'],
                                    description: item['description'],
                                    price: item['price'],
                                    stock: item['stock'],
                                    images: item['productImage'])),
                          ),
                        );
                      },
                      child: Text(
                        item['productName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              Colors.blue, // Highlight clickable text in blue
                          decoration: TextDecoration
                              .underline, // Add underline for clickable effect
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red,
                      onPressed: () => _removeFromFavorites(item['favoriteId']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
