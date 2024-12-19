import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MyAccount.dart';
import '../auth.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? errorMessage = '';

  Future<void> _changePassword() async {
    final auth = Auth();
    final user = auth.currentUser;

    if (user == null) {
      setState(() {
        errorMessage = "No user is currently logged in.";
      });
      return;
    }

    try {
      // Reauthenticate the user with the old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Check if the new passwords match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          errorMessage = "New passwords do not match.";
        });
        return;
      }

      // Update the password
      await user.updatePassword(_newPasswordController.text);

      // Navigate to MyAccount and show success message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyAccount()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const greenColor = Color.fromARGB(255, 58, 183, 141);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: greenColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              _buildPasswordField("Old Password", _oldPasswordController,
                  obscureText: true),
              const SizedBox(height: 16),
              _buildPasswordField("New Password", _newPasswordController,
                  obscureText: true),
              const SizedBox(height: 16),
              _buildPasswordField(
                  "Confirm New Password", _confirmPasswordController,
                  obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
