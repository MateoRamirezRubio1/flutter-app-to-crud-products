import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:convert';

/// Service class for interacting with the API.
class ApiService {
  /// Base URL for the API.
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://default-url.com';

  /// Fetches the list of products from the API.
  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$baseUrl/api/v1/products');
    try {
      final response = await http.get(uri);
      _handleRateLimit(response);

      /// Manage limit of requests
      _checkResponse(response, successStatusCodes: [200]);

      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      if (e is RateLimitExceededException) {
        throw e;
      } else {
        throw Exception('Failed to load products: $e');
      }
    }
  }

  /// Fetches an image from the API given its path.
  Future<http.Response> fetchImage(String imagePath) async {
    final uri = Uri.parse('$baseUrl/uploads/images/$imagePath');
    try {
      final response = await http.get(uri);
      _handleRateLimit(response);

      /// Manage limit of requests
      _checkResponse(response, successStatusCodes: [200]);

      return response;
    } catch (e) {
      if (e is RateLimitExceededException) {
        throw e;
      } else {
        throw Exception('Failed to load image: $e');
      }
    }
  }

  /// Creates a new product by sending a POST request to the API.
  Future<void> postCreateProduct(Product product) async {
    final uri = Uri.parse('$baseUrl/api/v1/products');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = product.name;
    request.fields['price'] = product.price;
    request.fields['description'] = product.description;

    if (product.image_path != null) {
      final file = File(product.image_path!);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        file.path,
      ));
    }

    try {
      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);
      _handleRateLimit(httpResponse);

      /// Manage limit of requests
      _checkResponse(httpResponse, successStatusCodes: [200, 201]);
    } catch (e) {
      if (e is RateLimitExceededException) {
        throw e;
      } else {
        throw Exception('Failed to submit product: $e');
      }
    }
  }

  /// Updates an existing product by sending a PUT request to the API.
  Future<void> putUpdateProduct(Product product, bool newImage) async {
    final uri = Uri.parse('$baseUrl/api/v1/products/${product.id}');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['name'] = product.name;
    request.fields['price'] = product.price;
    request.fields['description'] = product.description;

    if (newImage == true) {
      final file = File(product.image_path!);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        file.path,
      ));
    }
    if (product.image_path != null && newImage == false) {
      request.fields['image_path'] = product.image_path!;
    }

    try {
      final response = await request.send();
      final httpResponse = await http.Response.fromStream(response);
      _handleRateLimit(httpResponse);

      /// Manage limit of requests
      _checkResponse(httpResponse, successStatusCodes: [200, 201]);
    } catch (e) {
      if (e is RateLimitExceededException) {
        throw e;
      } else {
        throw Exception('Failed to update product: $e');
      }
    }
  }

  /// Deletes a product by sending a DELETE request to the API.
  Future<void> deleteProduct(int productId) async {
    final uri = Uri.parse('$baseUrl/api/v1/products/$productId');
    try {
      final response = await http.delete(uri);
      _handleRateLimit(response);

      /// Manage limit of requests
      _checkResponse(response, successStatusCodes: [204]);
    } catch (e) {
      if (e is RateLimitExceededException) {
        throw e;
      } else {
        throw Exception('Failed to delete product: $e');
      }
    }
  }

  /// Checks the response status code for success.
  void _checkResponse(http.Response response,
      {List<int> successStatusCodes = const [200]}) {
    if (!successStatusCodes.contains(response.statusCode)) {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  /// Function to handle status code 429
  void _handleRateLimit(http.Response response) {
    if (response.statusCode == 429) {
      throw RateLimitExceededException(
          'Too many requests. Please wait before trying again.');
    }
  }
}

/// Customised exception for the limit of applications
class RateLimitExceededException implements Exception {
  final String message;
  RateLimitExceededException(this.message);

  @override
  String toString() => message;
}
