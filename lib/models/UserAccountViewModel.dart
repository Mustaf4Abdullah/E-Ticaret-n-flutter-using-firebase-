import 'Addresses.dart';
import 'Order.dart' as local_order;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountViewModel {
  final String userName;
  final String email;
  final List<local_order.Order> orderHistory;
  final List<Addresses> savedAddresses;

  UserAccountViewModel({
    required this.userName,
    required this.email,
    required this.orderHistory,
    required this.savedAddresses,
  });

  // Convert a UserAccountViewModel into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'orderHistory': orderHistory.map((order) => order.toMap()).toList(),
      'savedAddresses':
          savedAddresses.map((address) => address.toMap()).toList(),
    };
  }

  // Create a UserAccountViewModel object from a Firestore document snapshot
  factory UserAccountViewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return UserAccountViewModel(
      userName: data?['userName'] ?? '',
      email: data?['email'] ?? '',
      orderHistory: (data?['orderHistory'] as List<dynamic>?)
              ?.map((order) =>
                  local_order.Order.fromFirestore(order as DocumentSnapshot))
              .toList() ??
          [],
      savedAddresses: (data?['savedAddresses'] as List<dynamic>?)
              ?.map((address) =>
                  Addresses.fromFirestore(address as DocumentSnapshot))
              .toList() ??
          [],
    );
  }
}
