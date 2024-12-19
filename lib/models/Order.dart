import 'OrderItem.dart';

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

  // Create an Order object from a Map (useful for local use and Firestore)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      orderDate:
          DateTime.parse(map['orderDate'] ?? DateTime.now().toIso8601String()),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
