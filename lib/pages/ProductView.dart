import 'package:flutter/material.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/services/cartService.dart';
import 'package:mobileapp/services/favoriteService.dart';

class ProductView extends StatelessWidget {
  final Product product;

  const ProductView({Key? key, required this.product}) : super(key: key);

  void _addToCart(BuildContext context, Product product) async {
    if (Auth().currentUser == null) {
      _showSignInMessage(context);
      return;
    }
    CartService().addCartItem(CartItem(
      id: product.id,
      productId: product.id,
      name: product.name,
      description: product.description,
      stock: product.stock,
      price: product.price,
      quantity: 1,
      images: product.images,
    ));
    _showSnackBar(context, 'Added to cart');
  }

  void _addToFavorites(BuildContext context, Product product) async {
    if (Auth().currentUser == null) {
      _showSignInMessage(context);
      return;
    }

    final favoriteService = FavoriteService();
    final userId = await Auth().getCurrentUserId();

    // Check if the product is already in favorites
    final docRef =
        favoriteService.favoriteCollection.doc('${userId}_${product.id}');
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      _showSnackBar(context, 'Product is already in favorites');
    } else {
      await favoriteService.addFavorite(FavoriteItem(
        id: product.id,
        productId: product.id,
        name: product.name,
        description: product.description,
        stock: product.stock,
        images: product.images,
        price: product.price,
      ));
      _showSnackBar(context, 'Added to favorites');
    }
  }

  void _showSignInMessage(BuildContext context) {
    _showSnackBar(context, 'Please sign in to continue');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: Uri.tryParse(product.images.isNotEmpty
                                  ? product.images[0]
                                  : '')
                              ?.isAbsolute ==
                          true
                      ? NetworkImage(product.images[0])
                      : const NetworkImage(
                          'https://via.placeholder.com/150'), // Fallback placeholder
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  // Stock Info
                  Text(
                    "Stock: ${product.stock}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (product.category != null) // Check if category is not null
                    Text(
                      'Category: ${product.category}',
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  // Add to Cart and Favorites Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _addToCart(context, product),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 58, 183, 141),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _addToFavorites(context, product),
                        icon: const Icon(Icons.favorite_border),
                        label: const Text("Add to Favorites"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
