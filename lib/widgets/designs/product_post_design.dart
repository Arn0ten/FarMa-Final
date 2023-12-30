import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agriplant/components/my_button.dart';
import 'package:agriplant/components/my_textfield.dart';

class ProductPostPageDesign extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController unitController;
  final String imagePath;
  final Function()? pickImage;
  final Function()? postProduct;

  const ProductPostPageDesign({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.unitController,
    required this.imagePath,
    required this.pickImage,
    required this.postProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imagePath.isEmpty
                    ? Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.grey[500],
                )
                    : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            MyTextField(
              controller: nameController,
              hintText: 'Product Name',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: descriptionController,
              hintText: 'Product Description',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: priceController,
              hintText: 'Product Price',
              obscureText: false,
              prefixIcon: Icons.attach_money,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: unitController,
              hintText: 'Product Unit',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            MyButton(
              onTap: postProduct,
              text: 'Post Product',
            ),
          ],
        ),
      ),
    );
  }
}

