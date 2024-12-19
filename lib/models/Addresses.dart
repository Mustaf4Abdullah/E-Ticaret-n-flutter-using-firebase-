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

  // Create an Address object from a Map
  factory Addresses.fromMap(Map<String, dynamic> map, String id) {
    return Addresses(
      id: id,
      userId: map['userId'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
    );
  }
}
