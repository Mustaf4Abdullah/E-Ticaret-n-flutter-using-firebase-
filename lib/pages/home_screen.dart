import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/pages/ProductByCatagory.dart';
import 'package:mobileapp/pages/ProductView.dart';
import 'package:mobileapp/pages/login_register_page.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/productPage.dart';
import 'package:mobileapp/services/productServics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  String? errorMessage;
  List<Product> searchResults = [];
  String searchQuery = '';

  void performSearch(String query) {
    if (query.isNotEmpty) {
      productService.searchProducts(query).listen((results) {
        setState(() {
          searchResults = results;
        });
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      productService.getProducts().listen((productList) {
        setState(() {
          products = productList;
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
      });
    }
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
            color: const Color.fromARGB(255, 58, 183, 141),
            width: 2), // Green border around card
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                product.images.isNotEmpty &&
                        Uri.tryParse(product.images[0])?.isAbsolute == true
                    ? product.images[0]
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                height: 150.0, // Increased height
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.description,
              style: TextStyle(
                  color: Colors.grey[700]), // Light grey text for description
            ),
            const SizedBox(height: 10),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Stock: ${product.stock}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bazaarly'),
        backgroundColor:
            const Color.fromARGB(255, 58, 183, 141), // Match AppBar color
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
            // Navigation Menu
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to Dashboard
                    },
                    child: Text('Home',
                        style: TextStyle(color: Colors.blue)), // Blue for text
                  ),
                  DropdownButton<String>(
                    hint: const Text('Categories',
                        style: TextStyle(color: Colors.blue)),
                    items: <String>[
                      'House Equipment',
                      'Electronics',
                      'Clothes',
                      'Accessories'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductByCategory(category: newValue),
                          ),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text('Cart', style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child:
                        Text('Favorites', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Search Bar
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      performSearch(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  if (searchResults.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final product = searchResults[index];
                        return ListTile(
                          title: Text(product.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductView(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),

            // Account Button
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text('Login', style: TextStyle(color: Colors.blue)),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductView(product: product),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: Uri.tryParse(product.images.isNotEmpty
                                            ? product.images[0]
                                            : '')
                                        ?.isAbsolute ==
                                    true
                                ? NetworkImage(product.images[0])
                                : const NetworkImage(
                                    'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductView(product: product),
                            ),
                          );
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
                                child: product.images.isNotEmpty
                                    ? Image.network(
                                        product.images[0],
                                        fit: BoxFit.cover,
                                        height: 120.0,
                                        width: double.infinity,
                                      )
                                    : Image.network(
                                        product.images.isNotEmpty
                                            ? product.images[0]
                                            : 'https://via.placeholder.com/150', // Placeholder image URL
                                        fit: BoxFit.cover,
                                        height: 150.0,
                                        width: double.infinity,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
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
                                  product.description,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Price: \$${product.price}',
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
