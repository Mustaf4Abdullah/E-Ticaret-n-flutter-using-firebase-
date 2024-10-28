import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String id;
  final String imageUrl;
  final String productId;

  ImageModel({
    required this.id,
    required this.imageUrl,
    required this.productId,
  });

  // Convert an ImageModel into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'productId': productId,
    };
  }

  // Create an ImageModel object from a Firestore document snapshot
  factory ImageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return ImageModel(
      id: data?['id'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      productId: data?['productId'] ?? '',
    );
  }
}
