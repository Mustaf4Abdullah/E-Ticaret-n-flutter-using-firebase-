import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String description;
  final String notes;
  final double salary;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.description,
    required this.notes,
    required this.salary,
  });
// Convert an Employee into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'description': description,
      'notes': notes,
      'salary': salary,
    };
  }

// Create an Employee object from a Firestore document snapshot
  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null safety
    return Employee(
      id: data?['id'] ?? '',
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      description: data?['description'] ?? '',
      notes: data?['notes'] ?? '',
      salary: (data?['salary'] ?? 0).toDouble(),
    );
  }
}
