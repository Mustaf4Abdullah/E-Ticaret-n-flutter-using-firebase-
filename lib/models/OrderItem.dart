import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final int productId;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  // Convert an OrderItem into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create an OrderItem object from a Firestore document snapshot
  factory OrderItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return OrderItem(
      productId: data?['productId'] ??
          0, // Provide default values if fields are missing
      name: data?['name'] ?? '',
      price: data?['price'] ?? 0.0,
      quantity: data?['quantity'] ?? 0,
    );
  }

  // Create an OrderItem object from a Map

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? 0,
      name: map['name'] ?? '',
      price: map['price'] ?? 0.0,
      quantity: map['quantity'] ?? 0,
    );
  }
}
