import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../screens/product_edit_screen.dart';

/// **ProductDetailScreen** is a StatelessWidget that displays detailed information about a product.
class ProductDetailScreen extends StatelessWidget {
  /// The product whose details are to be displayed.
  final Product product;

  /// An instance of ApiService to fetch product-related data.
  final ApiService _apiService = ApiService();

  /// Creates a [ProductDetailScreen] with the specified [product].
  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProductImage(),
            const SizedBox(height: 20),
            _buildProductDetails(context),
          ],
        ),
      ),
    );
  }

  /// Builds a widget to display the product image.
  Widget _buildProductImage() {
    return FutureBuilder<Uint8List>(
      future: _fetchImage(),
      builder: (context, snapshot) {
        Widget imageWidget;

        // Handle different states of the FutureBuilder
        if (snapshot.connectionState == ConnectionState.waiting) {
          imageWidget = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          imageWidget = Image.asset('assets/default.jpg', fit: BoxFit.contain);
        } else {
          imageWidget = Image.memory(snapshot.data!, fit: BoxFit.contain);
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              image: snapshot.hasData
                  ? DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: imageWidget,
          ),
        );
      },
    );
  }

  /// Builds a widget to display the details of the product (name, price, description).
  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${product.price}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }

  /// Builds a widget for action buttons (e.g., Edit button).
  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductEditScreen(product: product),
              ),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  /// Fetches the image data from the API service.
  ///
  /// Returns a [Future] that resolves to the image data as [Uint8List].
  Future<Uint8List> _fetchImage() async {
    final response = await _apiService.fetchImage(product.image_path!);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
