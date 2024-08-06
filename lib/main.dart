import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './feature_1/screens/product_list_screen.dart';

/// **MainApp** is the entry point of the Flutter application.
/// It sets up the application's theme and the home screen.
class MainApp extends StatelessWidget {
  /// Creates an instance of [MainApp].
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products App', // Title of the application
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Primary color scheme for the app
        ),
        useMaterial3: true, // Use the latest Material Design 3 components
      ),
      home: const ProductListScreen(), // Home screen of the application
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(const MainApp()); // Runs the app
}
