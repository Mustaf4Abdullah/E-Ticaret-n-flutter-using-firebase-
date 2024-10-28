import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String productId;
  final String userId;

  Favorite({
    required this.id,
    required this.productId,
    required this.userId,
  });

  // Convert a Favorite into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
    };
  }

  // Create a Favorite object from a Firestore document snapshot
  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Favorite(
      id: data?['id'] ?? '',
      productId: data?['productId'] ?? '',
      userId: data?['userId'] ?? '',
    );
  }
}
