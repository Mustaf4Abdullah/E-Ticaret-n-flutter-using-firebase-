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
  String? _selectedCategory; // To hold the selected category

  final List<String> categories = [
    'House Equipment',
    'Electronics',
    'Clothes',
    'Accessories'
  ]; // Predefined categories

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
      id: DateTime.now().toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      stock: int.tryParse(_stockController.text) ?? 0,
      images: _imagesController.text.split(',').map((e) => e.trim()).toList(),
      category: _selectedCategory, // Add selected category
    );

    productService.addProduct(newProduct).then((_) {
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _editProduct(Product product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _imagesController.text = product.images.join(',');
    _selectedCategory = product.category; // Prepopulate selected category

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
                    .map((e) => e.trim())
                    .toList(),
                category: _selectedCategory, // Update category
              );

              productService.updateProduct(updatedProduct).then((_) {
                _clearForm();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product updated successfully!'),
                    backgroundColor: Colors.blueAccent,
                  ),
                );
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              productService.deleteProduct(productId).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              });
              Navigator.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _imagesController.clear();
    _selectedCategory = null; // Reset category
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Price'),
        ),
        TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Stock'),
        ),
        TextField(
          controller: _imagesController,
          decoration: InputDecoration(labelText: 'Image URL (comma-separated)'),
        ),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(labelText: 'Category'),
          items: categories
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildForm(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: product.images.isNotEmpty
                          ? NetworkImage(
                              product.images[0]) // Display the first image URL
                          : null,
                      backgroundColor: Colors.blueAccent,
                      child:
                          product.images.isEmpty ? Text(product.name[0]) : null,
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Category: ${product.category ?? 'Uncategorized'}\nPrice: \$${product.price}, Stock: ${product.stock}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _editProduct(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteProduct(product.id),
                        ),
                      ],
                    ),
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
