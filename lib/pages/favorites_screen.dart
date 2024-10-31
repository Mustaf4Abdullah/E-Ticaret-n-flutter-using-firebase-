import 'package:flutter/material.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/pages/favorites_screen.dart';
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
    favoriteService
        .dispose(); // Stop listening to any active streams in favoriteService
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
          });
        }
      }
      if (mounted) {
        // Ensure the widget is still in the tree
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favoriteItems.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return ListTile(
                  title: Text(item['productName']),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => _removeFromFavorites(item['favoriteId']),
                  ),
                );
              },
            ),
    );
  }
}
