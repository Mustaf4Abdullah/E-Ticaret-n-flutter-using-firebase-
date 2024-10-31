import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarlyUser {
  final String id;
  final String email;
  final String role;

  // Static variable to hold the current user's ID

  BazaarlyUser({
    required this.id,
    required this.email,
    required this.role,
  });

  // Convert a BazaarlyUser into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }

  // Create a BazaarlyUser object from a Firestore document snapshot
  factory BazaarlyUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return BazaarlyUser(
      id: data?['id'] ?? '',
      email: data?['email'] ?? '',
      role: data?['role'] ?? '',
    );
  }
}
