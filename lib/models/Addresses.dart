import 'package:cloud_firestore/cloud_firestore.dart';

class Addresses {
  final String id;
  final String userId;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Addresses({
    required this.id,
    required this.userId,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  String get fullAddress => '$street, $city, $state, $zipCode, $country';

  // Convert an Address into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  // Create an Address object from a Firestore document snapshot
  factory Addresses.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Addresses(
      id: doc.id,
      userId:
          data?['userId'] ?? '', // Provide default values if fields are missing
      street: data?['street'] ?? '',
      city: data?['city'] ?? '',
      state: data?['state'] ?? '',
      zipCode: data?['zipCode'] ?? '',
      country: data?['country'] ?? '',
    );
  }
}
