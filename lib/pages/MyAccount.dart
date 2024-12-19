import 'package:flutter/material.dart';
import 'package:mobileapp/models/user_account_view_model.dart.dart';
import 'package:mobileapp/pages/AddAddressPage.dart';
import 'package:mobileapp/pages/ChangePassword.dart';
import 'package:mobileapp/services/AddressService.dart';
import 'package:mobileapp/services/OrderService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccount> {
  final AddressService _addressService = AddressService();
  final OrderService _orderService = OrderService();
  late UserAccountViewModel _userAccount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch addresses and order history
        final addresses = await _addressService.getAddressesByUser(user.uid);
        final orders = await _orderService.getOrdersByUser(user.uid);

        final userAccount = UserAccountViewModel(
          userName: user.displayName ?? "User",
          email: user.email ?? "No Email",
          orderHistory: orders,
          savedAddresses: addresses,
        );

        setState(() {
          _userAccount = userAccount;
          _isLoading = false;
        });
      } else {
        throw Exception("No authenticated user found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .pushReplacementNamed('home_screen'); // Redirect to HomeScreen
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  Widget _buildOrderHistory() {
    if (_userAccount.orderHistory.isEmpty) {
      return Center(child: Text("No orders yet."));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _userAccount.orderHistory.length,
      itemBuilder: (context, index) {
        final order = _userAccount.orderHistory[index];
        return ListTile(
          title: Text("Order ID: ${order.orderId}"),
          subtitle: Text("Date: ${order.orderDate.toLocal()}"),
          trailing: Text("Total: \$${order.totalPrice.toStringAsFixed(2)}"),
        );
      },
    );
  }

  Widget _buildSavedAddresses() {
    if (_userAccount.savedAddresses.isEmpty) {
      return Center(child: Text("No saved addresses."));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _userAccount.savedAddresses.length,
      itemBuilder: (context, index) {
        final address = _userAccount.savedAddresses[index];
        return ListTile(
          title: Text(address.fullAddress),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  // Call edit address logic
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Call delete address logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 58, 183, 141);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${_userAccount.userName}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Email: ${_userAccount.email}",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                    child: const Text("Change Password"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Order History", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  _buildOrderHistory(),
                  SizedBox(height: 16),
                  Text("Saved Addresses", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  _buildSavedAddresses(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddAddressPage()),
                      );
                    },
                    child: Text("Add Address"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
