import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final String id; // This could still be the Firestore document ID
  final String productId;
  final String name;
  final double price;
  String userId = '';

  FavoriteItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.userId = '',
  });

  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      price: data['price'],
      userId: data['userId'], // Add userId to the factory constructor
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'userId': userId, // Add userId to the toMap method
    };
  }
}
