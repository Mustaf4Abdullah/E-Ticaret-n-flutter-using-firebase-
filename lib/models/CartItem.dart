import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id; // This could still be the Firestore document ID
  final String productId;
  final String name;
  final double price;
  int quantity;
  String userId = '';

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.userId = '',
    // Include userId in the constructor
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      userId: data['userId'], // Add userId to the factory constructor
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'userId': userId, // Add userId to the toMap method
    };
  }
}
