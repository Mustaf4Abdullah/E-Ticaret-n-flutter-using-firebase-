import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ürün ekle
  Future<void> addProduct(Product product) {
    return _db.collection('products').doc(product.id).set(product.toMap());
  }

  // Ürün güncelle
  Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.id).update(product.toMap());
  }

  // Ürünleri listele
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }
}
