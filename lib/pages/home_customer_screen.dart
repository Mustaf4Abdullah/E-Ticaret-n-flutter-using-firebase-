import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobileapp/auth.dart';
import 'package:mobileapp/models/CartItem.dart';
import 'package:mobileapp/models/favorite.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/pages/MyAccount.dart';
import 'package:mobileapp/pages/ProductByCatagory.dart';
import 'package:mobileapp/pages/home_screen.dart';
import 'package:mobileapp/services/cartService.dart';
import 'package:mobileapp/services/favoriteService.dart';
import 'package:mobileapp/services/productServics.dart';
import 'package:mobileapp/pages/cart_screen.dart';
import 'package:mobileapp/pages/favorites_screen.dart';
import 'package:mobileapp/pages/ProductView.dart';

class HomeCustomerScreen extends StatefulWidget {
  const HomeCustomerScreen({super.key});

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  List<Product> searchResults = [];
  String? errorMessage;
  String searchQuery = '';

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

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Color.fromARGB(255, 58, 183, 141),
          width: 2,
        ),
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
                height: 150.0,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported,
                      size: 50, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.description,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Stock: ${product.stock}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.blue),
                  onPressed: () {
                    showSnackBar(context, 'Added to favorites');
                    FavoriteService().addFavorite(FavoriteItem(
                      id: product.id,
                      productId: product.id,
                      name: product.name,
                      description: product.description,
                      stock: product.stock,
                      images: product.images,
                      price: product.price,
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart,
                      color: Color.fromARGB(255, 58, 183, 141)),
                  onPressed: () {
                    showSnackBar(context, 'Added to cart');
                    CartService().addCartItem(CartItem(
                      id: product.id,
                      productId: product.id,
                      name: product.name,
                      description: product.description,
                      stock: product.stock,
                      price: product.price,
                      quantity: 1,
                      images: product.images,
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

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bazaarly'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 141),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
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
                      // Navigate to Home
                    },
                    child: const Text('Home',
                        style: TextStyle(color: Colors.blue)),
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
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                    child: const Text('Cart',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesScreen()),
                      );
                    },
                    child: const Text('Favorites',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
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
