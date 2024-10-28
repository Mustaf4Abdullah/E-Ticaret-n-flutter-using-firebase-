import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information Section
            _buildSectionTitle('Personal Information'),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Name:', 'John Doe'),
                  _buildInfoRow('Email:', 'john.doe@example.com'),
                  _buildButton('Edit Profile', () {
                    // Navigate to Edit Profile
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Change Password Section
            _buildSectionTitle('Change Password'),
            _buildCard(
              _buildButton('Change Password', () {
                // Navigate to Change Password
              }),
            ),
            const SizedBox(height: 16.0),
            // Order History Section
            _buildSectionTitle('Order History'),
            _buildCard(
              Column(
                children: [
                  _buildOrderHistoryTable(),
                  const SizedBox(height: 16.0),
                  _buildButton('View All Orders', () {
                    // Navigate to Order History
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Saved Addresses Section
            _buildSectionTitle('Saved Addresses'),
            _buildCard(
              Column(
                children: [
                  _buildAddressList(),
                  const SizedBox(height: 16.0),
                  _buildButton('Add New Address', () {
                    // Navigate to Add Address
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Logout Section
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Perform logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC8A71F),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Color(0xFFC8A71F)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFC8A71F),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFC8A71F)),
      ),
      child: Text(label),
    );
  }

  Widget _buildOrderHistoryTable() {
    return Table(
      border: TableBorder.all(color: Color(0xFFC8A71F)),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFC8A71F)),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Order ID', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Date', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Total Items', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Status', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Actions', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        // Example order row
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('12345'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('2023-10-01'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('3'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Completed'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Order Details
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFC8A71F),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressList() {
    return Column(
      children: [
        _buildAddressItem('123 Main St, Springfield, USA'),
        _buildAddressItem('456 Elm St, Springfield, USA'),
      ],
    );
  }

  Widget _buildAddressItem(String address) {
    return ListTile(
      title: Text(address),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFC8A71F)),
            onPressed: () {
              // Navigate to Edit Address
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFC8A71F)),
            onPressed: () {
              // Confirm and delete address
            },
          ),
        ],
      ),
    );
  }
}
