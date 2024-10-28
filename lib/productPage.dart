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
  final TextEditingController _imagesController = TextEditingController();

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
      images:
          _imagesController.text.split(',').map((e) => 'assets/$e').toList(),
    );

    productService.addProduct(newProduct).then((_) {
      _clearForm();
    });
  }

  void _editProduct(Product product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _imagesController.text = product.images.join(',');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: _buildForm(),
        actions: [
          TextButton(
            onPressed: () {
              final updatedProduct = Product(
                id: product.id,
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.tryParse(_priceController.text) ?? 0.0,
                stock: int.tryParse(_stockController.text) ?? 0,
                images: _imagesController.text
                    .split(',')
                    .map((e) => 'assets/$e')
                    .toList(),
              );

              productService.updateProduct(updatedProduct).then((_) {
                _clearForm();
                Navigator.of(context).pop();
              });
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              _clearForm();
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String productId) {
    productService.deleteProduct(productId);
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _imagesController.clear();
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(labelText: 'Description'),
        ),
        TextField(
          controller: _priceController,
          decoration: InputDecoration(labelText: 'Price'),
        ),
        TextField(
          controller: _stockController,
          decoration: InputDecoration(labelText: 'Stock'),
        ),
        TextField(
          controller: _imagesController,
          decoration:
              InputDecoration(labelText: 'Images (comma separated filenames)'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildForm(),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Price: \$${product.price}, Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProduct(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
