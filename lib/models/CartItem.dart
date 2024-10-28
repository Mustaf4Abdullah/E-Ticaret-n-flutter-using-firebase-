import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
