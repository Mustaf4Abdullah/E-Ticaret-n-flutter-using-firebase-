import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/User.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // Create a new user in Firebase Authentication
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // Save the user in Firestore with "customer" role by default
    final bazaarlyUser = BazaarlyUser(
      id: userCredential.user!.uid,
      email: email,
      role: 'customer', // Default role for new users
    );

    await _firestore
        .collection('users')
        .doc(bazaarlyUser.id)
        .set(bazaarlyUser.toMap());
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
