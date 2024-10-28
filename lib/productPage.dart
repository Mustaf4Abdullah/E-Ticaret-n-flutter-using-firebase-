import 'package:flutter/material.dart';
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/services/productServics.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService productService = ProductService();
  List<Product> products = [];

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to products
    productService.getProducts().listen((productList) {
      setState(() {
        products = productList;
      });
    });
  }

  void _addProduct() {
    final newProduct = Product(
      id: DateTime.now().toString(), // Unique ID
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      stock: int.tryParse(_stockController.text) ?? 0,
    );

    productService.addProduct(newProduct).then((_) {
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _stockController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          // Product addition form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name')),
                TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description')),
                TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price')),
                TextField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock')),
                ElevatedButton(
                    onPressed: _addProduct, child: Text('Add Product')),
              ],
            ),
          ),
          // Display product list
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Price: \$${product.price}, Stock: ${product.stock}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
