import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../screens/product_list_screen.dart';

/// A screen for editing product details.
class ProductEditScreen extends StatefulWidget {
  /// Creates a [ProductEditScreen] with the given [product].
  final Product product;

  const ProductEditScreen({Key? key, required this.product}) : super(key: key);

  @override
  ProductEditScreenState createState() => ProductEditScreenState();
}

class ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current product's data.
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price);
    _descriptionController =
        TextEditingController(text: widget.product.description);

    // Fetch the product's image if the path is available.
    if (widget.product.image_path != null &&
        widget.product.image_path!.isNotEmpty) {
      _fetchImage(widget.product.image_path!);
    }
  }

  /// Fetches the image from the API and returns it as [Uint8List].
  Future<Uint8List> _fetchImage(String imagePath) async {
    try {
      final response = await _apiService.fetchImage(imagePath);
      if (response.statusCode == 200) {
        return response.bodyBytes; // Convert response to bytes.
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching image: $e')),
      );
      return Uint8List(0); // Return empty bytes in case of error.
    }
  }

  /// Opens the image picker to allow the user to select an image.
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  /// Submits the form data to update the product.
  Future<void> _submitForm() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final product = Product(
        id: widget.product.id,
        name: _nameController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        image_path: _imageFile?.path ?? widget.product.image_path,
      );

      try {
        bool newImage = false;
        if (_imageFile?.path != null) {
          newImage = true;
        }
        await _apiService.putUpdateProduct(product, newImage);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
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
          SnackBar(content: Text('Failed to update product: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Form
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              // Pick Image Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[200],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: _pickImage,
                  child: const Icon(Icons.add_a_photo, size: 30),
                ),
              ),
              const SizedBox(height: 20),
              // Image Preview
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Container(
                      width: 200, // Width of the image container
                      height: 200, // Height of the image container
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit
                              .contain, // Fit the image within the container
                        ),
                      ),
                    ),
                  ),
                ),
              FutureBuilder<Uint8List>(
                future: widget.product.image_path != null &&
                        widget.product.image_path!.isNotEmpty
                    ? _fetchImage(widget.product.image_path!)
                    : Future.value(Uint8List(0)),
                builder: (context, snapshot) {
                  DecorationImage? decorationImage;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    decorationImage = const DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.contain,
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    decorationImage = const DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.contain,
                    );
                  } else if (snapshot.hasData) {
                    decorationImage = DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.contain,
                    );
                  } else {
                    decorationImage = const DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.contain,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Container(
                        width: 200, // Width of the image container
                        height: 200, // Height of the image container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: decorationImage,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
