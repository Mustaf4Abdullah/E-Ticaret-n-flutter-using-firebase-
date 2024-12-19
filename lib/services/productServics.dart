import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add product
  Future<void> addProduct(Product product) {
    return _db.collection('products').doc(product.id).set(product.toMap());
  }

  // Update product
  Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.id).update(product.toMap());
  }

  // Get products
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  // Delete product
  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  // Search for products by name
  Stream<List<Product>> searchProducts(String query) {
    return _db
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name',
            isLessThanOrEqualTo: query + '\uf8ff') // Handles prefix match
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Product>> getProductsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
}
