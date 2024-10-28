import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final int id;
  final String userName;
  final String content;
  final int productId;

  Comment({
    required this.id,
    required this.userName,
    required this.content,
    required this.productId,
  });

  // Convert a Comment into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'content': content,
      'productId': productId,
    };
  }

  // Create a Comment object from a Firestore document snapshot
  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Comment(
      id: data?['id'] ?? 0, // Provide default values if fields are missing
      userName: data?['userName'] ?? '',
      content: data?['content'] ?? '',
      productId: data?['productId'] ?? 0,
    );
  }
}
