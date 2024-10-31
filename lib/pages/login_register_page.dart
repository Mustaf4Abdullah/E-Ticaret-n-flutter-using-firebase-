import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/User.dart';
import 'package:mobileapp/pages/Home_Manager_Screen.dart';
import '../auth.dart';
import 'home_customer_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      final User? user = Auth().currentUser;
      if (user != null) {
        // Fetch user role from Firestore
        final DocumentSnapshot docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        //currentUserId = user.uid; // Add this line to store the user ID

        if (docSnapshot.exists) {
          final String userRole = docSnapshot['role'] ?? 'customer';

          // Navigate based on the user role
          if (userRole == 'manager') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeManagerScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeCustomerScreen()),
            );
          }
        } else {
          setState(() {
            errorMessage = 'User role not found';
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      final User? user = Auth().currentUser;
      if (user != null) {
        // Assign the default 'customer' role for new users
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'role': 'customer',
        });

        setState(() {
          errorMessage = 'Registration successful!';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCustomerScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget Title() {
    return Text(
      'Login or Register',
      style: TextStyle(fontSize: 24),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : errorMessage!,
      style: TextStyle(
        color: errorMessage == 'Login successful!' ||
                errorMessage == 'Registration successful!'
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = '';
        });
      },
      child: Text(isLogin ? 'Register' : 'Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _emailController),
            _entryField('Password', _passwordController),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
