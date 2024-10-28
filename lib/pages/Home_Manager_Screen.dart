import 'package:flutter/material.dart';
import 'package:mobileapp/productPage.dart';

class HomeManagerScreen extends StatefulWidget {
  const HomeManagerScreen({super.key});

  @override
  State<HomeManagerScreen> createState() => _HomeManagerScreenState();
}

class _HomeManagerScreenState extends State<HomeManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            // Left Section: Dashboard
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          // Image(
                          //   image: AssetImage('assets/login-logo.jpg'),
                          //   width: 200,
                          // ),
                          SizedBox(height: 20),
                          Text(
                            'Manager Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Manage your tasks here',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A71F),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Manage Products'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A71F),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('View Employees'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Messages and Reports
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A71F),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Messages and Reports'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to View Users
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A71F),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('View Users'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to View Orders
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A71F),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('View Orders'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Right Section: Info Section
            Expanded(
              flex: 1,
              child: Container(
                color: const Color(0xFFC8A71F),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Welcome, Manager',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Explore your dashboard and manage the marketplace effectively.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
