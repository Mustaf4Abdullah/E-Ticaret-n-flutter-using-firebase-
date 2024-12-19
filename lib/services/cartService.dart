import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/CartItem.dart';

class CartService {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  Future<String> _getUserId() async {
    return await Auth().getCurrentUserId();
  }

  // Stream to get all cart items
  Stream<List<CartItem>> getCartItems() async* {
    final userId = await _getUserId();
    yield* cartCollection.where('userId', isEqualTo: userId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                CartItem.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Add a new item or update its quantity
  Future<void> addCartItem(CartItem item) async {
    final userId = await _getUserId();
    item.userId = userId;
    final docRef = cartCollection.doc('${userId}_${item.productId}');

    final doc = await docRef.get();
    if (doc.exists) {
      // If it exists, update the quantity
      CartItem existingItem =
          CartItem.fromFirestore(doc.data() as Map<String, dynamic>);
      existingItem.quantity += item.quantity; // Update the quantity

      return docRef.set(existingItem.toMap());
    } else {
      // If it doesn't exist, add the new item
      return docRef.set(item.toMap());
    }
  }

  // Remove a cart item
  Future<void> removeCartItem(String productId) async {
    final userId = await _getUserId();
    return cartCollection.doc('${userId}_${productId}').delete();
  }

  // New: Update quantity of a cart item
  Future<void> updateCartItemQuantity(String productId, int newQuantity) async {
    final userId = await _getUserId();
    final docRef = cartCollection.doc('${userId}_$productId');

    final doc = await docRef.get();
    if (doc.exists) {
      // Update the quantity field
      await docRef.update({'quantity': newQuantity});
    }
  }
}
