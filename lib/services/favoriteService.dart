import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';

class FavoriteService {
  final CollectionReference favoriteCollection =
      FirebaseFirestore.instance.collection('favorites');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');
  Stream<List<FavoriteItem>>? _favoriteStream;

  Future<String> _getUserId() async {
    return await Auth().getCurrentUserId();
  }

  Stream<List<FavoriteItem>> getFavorites() async* {
    final userId = await _getUserId();
    _favoriteStream = favoriteCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              FavoriteItem.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
    yield* _favoriteStream!;
  }

  Future<void> addFavorite(FavoriteItem favorite) async {
    final userId = await _getUserId();
    favorite.userId = userId;
    final docRef = favoriteCollection.doc('${userId}_${favorite.productId}');

    // Check if favorite already exists
    if (!(await docRef.get()).exists) {
      await docRef.set(favorite.toMap());
    }
  }

  Future<void> removeFavorite(String productId) async {
    final userId = await _getUserId();
    return favoriteCollection.doc('${userId}_${productId}').delete();
  }

  Future<Product?> getProductById(String productId) async {
    final doc = await productCollection.doc(productId).get();
    if (doc.exists) {
      return Product.fromFirestore(doc);
    }
    return null;
  }

  void dispose() {
    _favoriteStream =
        null; // Set stream to null or close any specific stream controllers here
  }
}
