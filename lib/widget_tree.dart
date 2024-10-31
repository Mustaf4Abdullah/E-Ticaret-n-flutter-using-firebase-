import 'package:flutter/material.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/User.dart';
import 'package:mobileapp/pages/Home_Manager_Screen.dart';
import 'package:mobileapp/pages/home_customer_screen.dart';
import 'package:mobileapp/pages/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> _getUserRole(String uid) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot['role'];
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const HomeScreen();
          } else {
            return FutureBuilder<String?>(
              future: _getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.done) {
                  final role = roleSnapshot.data;
                  if (role == 'manager') {
                    return const HomeManagerScreen();
                  } else {
                    return const HomeCustomerScreen();
                  }
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
