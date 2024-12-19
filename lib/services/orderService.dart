import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/Order.dart' as local_order;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(local_order.Order order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toMap());
      print("Order successfully created.");
    } catch (e) {
      print("Error creating order: $e");
      throw Exception("Error creating order.");
    }
  }

  Future<List<local_order.Order>> getOrdersByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) =>
              local_order.Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching orders: $e");
      throw Exception("Error fetching orders.");
    }
  }
}
