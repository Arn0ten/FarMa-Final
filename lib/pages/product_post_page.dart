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
  String _deliveryMethod = 'Delivery';
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

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

    if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      _showSnackBar(context, 'Invalid price');
      return false;
    }

    if (_unitController.text.isEmpty) {
      _showSnackBar(context, 'Unit field cannot be empty');
      return false;
    }
    if (_locationController.text.isEmpty) {
      _showSnackBar(context, 'Location field cannot be empty');
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

  void _validateAndSaveProduct() async {
    if (!mounted) return;

    if (_validateForm(context)) {
      await _saveProduct(_getDeliveryMethod(), _getLocation());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }
  }

  String _getLocation() {
    return _locationController.text;
  }

  String _getDeliveryMethod() {
    return _deliveryMethod;
  }

  _saveProduct(String deliveryMethod, String getLocation) async {
    try {
      final String imageUrl =
          await ProductService().uploadImage(File(_imagePath));
      int tempAvailableQuantity = 10;
      String tempLocation = _getLocation();

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        PostedByUser postedByUser = PostedByUser(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
        );

        Product newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          description: _descriptionController.text,
          image: imageUrl,
          price: double.parse(_priceController.text),
          unit: _unitController.text,
          postedByUser: postedByUser,
          deliveryMethod: _deliveryMethod,
          availableQuantity: tempAvailableQuantity,
          location: tempLocation,
        );

        // Add the product to the database
        await ProductService().addProduct(
          newProduct,
          _deliveryMethod,
          tempAvailableQuantity,
          tempLocation,
        );

        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _unitController.clear();
        _imagePath = '';
        setState(() {});
        _showSnackBar(context, 'Product posted successfully');
      }
    } catch (e) {
      print('Failed to add product: $e');

      _showSnackBar(context, 'Failed to post product');
    }
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
      updateDeliveryMethod: (method) {
        setState(() {
          _deliveryMethod = method;
        });
      },
      selectedDeliveryMethod: _deliveryMethod,
      locationController: _locationController,
    );
  }
}
