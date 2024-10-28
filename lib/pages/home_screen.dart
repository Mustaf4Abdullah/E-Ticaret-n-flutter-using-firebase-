import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/pages/login_register_page.dart';
import 'package:mobileapp/productPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('Initializing HomeScreen...');
    }

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        products = [];
      });
      if (kDebugMode) {
        print('Products fetched: $products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bazaarly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Welcome to Bazaarly',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Butona tıklandığında ProductPage'e yönlendir
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              },
              child: Text('Go to Product Page'),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'We are an experienced team specializing in import and export, dedicated to ensuring safe and cost-effective delivery of goods.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Carousel for featured products
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: products.map((product) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(
                            product['images'] != null &&
                                    product['images']['values'].isNotEmpty
                                ? product['images']['values'][0]['imageUrl']
                                : 'https://example.com/default-image.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            // Product grid
            products.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'No products available.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to product details
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                child: product['images'] != null &&
                                        product['images']['values'].isNotEmpty
                                    ? Image.network(
                                        product['images']['values'][0]
                                            ['imageUrl'],
                                        fit: BoxFit.cover,
                                        height: 120.0,
                                        width: double.infinity,
                                      )
                                    : Image.network(
                                        'https://example.com/default-image.jpg',
                                        fit: BoxFit.cover,
                                        height: 120.0,
                                        width: double.infinity,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${product['description']}',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Price: ${product['price']} \$',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
