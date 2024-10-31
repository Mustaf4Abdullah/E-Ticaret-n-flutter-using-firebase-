import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/pages/MyAccount.dart';
import 'package:mobileapp/services/cartService.dart';
import 'package:mobileapp/services/favoriteService.dart';
import 'package:mobileapp/services/productServics.dart';
import 'package:mobileapp/pages/cart_screen.dart';
import 'package:mobileapp/pages/favorites_screen.dart';

class HomeCustomerScreen extends StatefulWidget {
  const HomeCustomerScreen({super.key});

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  String? errorMessage;

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
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                product.images.isNotEmpty
                    ? product.images[0]
                    : 'assets/default-image.jpg',
                fit: BoxFit.cover,
                height: 150.0, // Increased height
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 10),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Stock: ${product.stock}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Add to favorites
                    FavoriteService().addFavorite(FavoriteItem(
                      id: product.id,
                      productId: product.id,
                      name: product.name,
                      price: product.price,
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Add to cart
                    CartService().addCartItem(CartItem(
                      id: product.id,
                      productId: product.id,
                      name: product.name,
                      price: product.price,
                      quantity: 1,
                    ));
                  },
                ),
              ],
            ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccount()),
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
                    child: Text('Home'),
                  ),
                  DropdownButton<String>(
                    hint: Text('Categories'),
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
                      // Navigate to ProductsByCategory with the selected category
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                    child: Text('Cart'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesScreen()),
                      );
                    },
                    child: Text('Favorites'),
                  ),
                ],
              ),
            ),
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Perform search
                    },
                  ),
                ],
              ),
            ),
            // Account Button
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
                          image: AssetImage(
                            product.images.isNotEmpty
                                ? product.images[0]
                                : 'assets/default-image.jpg',
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
                        child: _buildProductCard(product),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
