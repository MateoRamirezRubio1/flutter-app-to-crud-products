import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../screens/product_list_screen.dart';

// Screen for creating a new product.
class ProductCreateScreen extends StatefulWidget {
  @override
  ProductCreateScreenState createState() => ProductCreateScreenState();
}

class ProductCreateScreenState extends State<ProductCreateScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Holds the selected image file
  File? _imageFile;

  // API service instance for network operations
  final ApiService _apiService = ApiService();
  // Image picker instance for selecting images
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Product'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text fields for product details
              _buildTextField(_nameController, 'Name'),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'Price'),
              const SizedBox(height: 16),
              _buildTextField(_descriptionController, 'Description'),
              const SizedBox(height: 20),
              // Image picker widget
              _buildImagePicker(),
              const SizedBox(height: 20),
              // Submit button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a text field with controller and label
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Widget for picking and displaying an image
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Pick an Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Icon(Icons.add_a_photo, size: 30), // Icon for the button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[100], // Light color
            foregroundColor: Colors.teal, // Icon color
            padding: const EdgeInsets.all(20), // Padding to make it circular
            shape: const CircleBorder(), // Circular shape
          ),
        ),
        const SizedBox(height: 16),
        // Display the selected image if available
        if (_imageFile != null) ...[
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // Removed border property
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.contain, // Adjust to show the entire image
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Builds the submit button for creating the product
  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitForm,
        child: const Text('Create Product'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Picks an image from the gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Log and show error if image picking fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Submits the form data to the API
  Future<void> _submitForm() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final product = Product(
        id: 0, // Assume id is not needed for creation
        name: _nameController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        image_path: _imageFile?.path, // Image path for the backend
      );

      try {
        await _apiService.postCreateProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductListScreen(),
          ),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
    }
  }
}
