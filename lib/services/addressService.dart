import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/Addresses.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(Addresses address) async {
    try {
      await _firestore.collection('addresses').add(address.toMap());
      print("Address successfully added.");
    } catch (e) {
      print("Error adding address: $e");
      throw Exception("Error adding address.");
    }
  }

  Future<void> editAddress(Addresses address) async {
    try {
      await _firestore
          .collection('addresses')
          .doc(address.id)
          .update(address.toMap());
      print("Address successfully updated.");
    } catch (e) {
      print("Error updating address: $e");
      throw Exception("Error updating address.");
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _firestore.collection('addresses').doc(addressId).delete();
      print("Address successfully deleted.");
    } catch (e) {
      print("Error deleting address: $e");
      throw Exception("Error deleting address.");
    }
  }

  Future<List<Addresses>> getAddressesByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) =>
              Addresses.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching addresses: $e");
      throw Exception("Error fetching addresses.");
    }
  }
}
