import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final String id; // This could still be the Firestore document ID
  final String productId;
  final String name;
  final double price;
  final String description;
  int stock;
  final List<String> images;
  String userId = '';

  FavoriteItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.userId = '',
    required this.stock,
    required this.images,
    required this.description,
  });

  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      description: data?['description'] ?? '',
      stock: data?['stock'] ?? 0,
      price: data['price'],
      images: List<String>.from(data?['images'] ?? []),

      userId: data['userId'], // Add userId to the factory constructor
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'userId': userId,
      'images': images,
      'description': description,
      'stock': stock,
      // Add userId to the toMap method
    };
  }
}
