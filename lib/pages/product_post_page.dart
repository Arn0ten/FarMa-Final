// product_post_page.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../models/product.dart';
import '../services/product/product_service.dart';
import '../widgets/designs/product_post_design.dart';
import 'explore_page.dart';
import 'home_page.dart';


class ProductPostPage extends StatefulWidget {
  const ProductPostPage({Key? key}) : super(key: key);

  @override
  _ProductPostPageState createState() => _ProductPostPageState();
}

class _ProductPostPageState extends State<ProductPostPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  String _imagePath = '';
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  bool _validateForm(BuildContext context) {
    if (_nameController.text.isEmpty) {
      _showSnackBar(context, 'Name field cannot be empty');
      return false;
    }

    if (_descriptionController.text.isEmpty) {
      _showSnackBar(context, 'Description field cannot be empty');
      return false;
    }

    if (_priceController.text.isEmpty || double.tryParse(_priceController.text) == null) {
      _showSnackBar(context, 'Invalid price');
      return false;
    }

    if (_unitController.text.isEmpty) {
      _showSnackBar(context, 'Unit field cannot be empty');
      return false;
    }

    if (_imagePath.isEmpty) {
      _showSnackBar(context, 'Please select an image');
      return false;
    }

    // All validations passed
    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _validateAndSaveProduct() {
    if (_validateForm(context)) {
      _saveProduct();
      // Navigate to the Explore page after successfully posting a product
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }


  // Inside _ProductPostPageState class
  void _saveProduct() async {
    try {
      // Upload the image and get the download URL
      final String imageUrl = await ProductService().uploadImage(File(_imagePath));

      // Get the current user from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Create a PostedByUser instance
        PostedByUser postedByUser = PostedByUser(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
        );

        // Create a Product instance with the necessary information
        Product newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          description: _descriptionController.text,
          image: imageUrl,
          price: double.parse(_priceController.text),
          unit: _unitController.text,
          postedByUser: postedByUser,
        );

        // Add the product to the database
        await ProductService().addProduct(newProduct);

        // Clear the form fields after successful submission
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _unitController.clear();
        _imagePath = '';
        setState(() {});
      } else {
        // Handle the case when the user is not authenticated
        print('User is not authenticated.');
      }
    } catch (e) {
      // Handle error
      print('Failed to add product: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _unitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductPostPageDesign(
      nameController: _nameController,
      descriptionController: _descriptionController,
      priceController: _priceController,
      unitController: _unitController,
      imagePath: _imagePath,
      pickImage: _pickImage,
      postProduct: _validateAndSaveProduct,
    );
  }
}
