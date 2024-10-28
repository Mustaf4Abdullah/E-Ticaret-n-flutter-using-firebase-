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
}
