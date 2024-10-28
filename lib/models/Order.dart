import 'OrderItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId;
  final String userId;
  final DateTime orderDate;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    required this.items,
  });

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.totalPrice);

  // Convert an Order into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Create an Order object from a Firestore document snapshot
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Order(
      orderId: data?['orderId'] ?? '',
      userId: data?['userId'] ?? '',
      orderDate: DateTime.parse(
          data?['orderDate'] ?? DateTime.now().toIso8601String()),
      items: (data?['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
