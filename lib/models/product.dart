import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final String? category; // Add category field which can be null

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    this.category, // Initialize category
  });

  // Convert a Product into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'images': images,
      'category': category, // Add category to map
    };
  }

  // Create a Product object from a Firestore document snapshot
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Product(
      id: data?['id'] ?? '',
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      price: (data?['price'] ?? 0).toDouble(),
      stock: data?['stock'] ?? 0,
      images: List<String>.from(data?['images'] ?? []),
      category: data?['category'], // Handle category which can be null
    );
  }
}
