import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_create_screen.dart';
import 'product_detail_screen.dart';

// Screen for displaying the list of products.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  // API service instance for network operations
  final ApiService _apiService = ApiService();
  // Future that holds the list of products
  late Future<List<Product>> _productListFuture;

  @override
  void initState() {
    super.initState();
    // Load products when the screen is initialized
    _loadProducts();
  }

  // Loads the list of products from the API
  void _loadProducts() {
    setState(() {
      _productListFuture = _apiService.fetchProducts();
    });
  }

  // Refreshes the product list
  Future<void> _refreshProducts() async {
    _loadProducts();
  }

  // Shows a confirmation dialog before deleting a product
  Future<void> _confirmDelete(int productId) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _apiService.deleteProduct(productId);
        if (mounted) {
          _refreshProducts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.teal,
        actions: [
          // Button to navigate to the product creation screen
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductCreateScreen()),
              ).then(
                  (_) => _refreshProducts()); // Refresh product list on return
            },
          ),
          // Button to refresh the product list
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productListFuture,
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if data fetch fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if no products are found
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          // Build list view of products
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: _buildProductImage(product.image_path),
                  title: Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${product.price} - ${product.description}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(product.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Builds the product image widget
  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null) {
      return const Icon(Icons.image, size: 50);
    }

    return FutureBuilder<http.Response>(
      future: _apiService.fetchImage(imagePath),
      builder: (context, imageSnapshot) {
        // Show loading indicator while fetching image
        if (imageSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (imageSnapshot.hasError) {
          // Show error icon if image fetch fails
          return const Icon(Icons.error, size: 50);
        } else if (imageSnapshot.hasData &&
            imageSnapshot.data!.statusCode == 200) {
          // Display the fetched image
          return Image.memory(imageSnapshot.data!.bodyBytes,
              width: 50, height: 50, fit: BoxFit.cover);
        } else {
          return const Icon(Icons.image, size: 50);
        }
      },
    );
  }
}
