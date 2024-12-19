import 'package:flutter/material.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/services/productServics.dart';
import 'package:mobileapp/pages/ProductView.dart';

class ProductByCategory extends StatefulWidget {
  final String category; // Pass category as a parameter

  const ProductByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<ProductByCategory> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    try {
      productService
          .getProductsByCategory(widget.category)
          .listen((productList) {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(product: product),
          ),
        );
      },
      child: Card(
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Products'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 141),
      ),
      body: products.isEmpty
          ? Center(
              child: Text(
                errorMessage ?? 'No products found in this category.',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(product);
              },
            ),
    );
  }
}
