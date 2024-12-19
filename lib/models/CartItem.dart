import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id; // This could still be the Firestore document ID
  final String productId;
  final String name;
  final double price;
  final String description;
  int quantity;
  int stock;
  String userId = '';
  final List<String> images;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.userId = '',
    required this.stock,
    required this.images,
    required this.description,
    // Include userId in the constructor
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      description: data?['description'] ?? '',
      stock: data?['stock'] ?? 0,
      price: data['price'],
      quantity: data['quantity'],
      userId: data['userId'],
      images: List<String>.from(data?['images'] ?? []),
      // Add userId to the factory constructor
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'quantity': quantity,
      'userId': userId,
      'images': images,
      // Add userId to the toMap method
    };
  }
}
