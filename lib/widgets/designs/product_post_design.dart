// product_post_design.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';

class ProductPostPageDesign extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController unitController;
  final String imagePath;
  final Function()? pickImage;
  final Function()? postProduct;
  final Function(String) updateDeliveryMethod;
  final String selectedDeliveryMethod;

  const ProductPostPageDesign({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.unitController,
    required this.imagePath,
    required this.pickImage,
    required this.postProduct,
    required this.updateDeliveryMethod,
    required this.selectedDeliveryMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
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
            ),
            _buildTextField(nameController, 'Product Name:'),
            const SizedBox(height: 15),
            _buildTextField(descriptionController, 'Product Description:'),
            const SizedBox(height: 15),
            _buildTextField(priceController, 'Product Price:', prefixIcon: Icons.attach_money),
            const SizedBox(height: 15),
            _buildTextField(unitController, 'Product Unit:'),
            const SizedBox(height: 15),
            _buildDeliveryMethodDropdown(),
            const SizedBox(height: 15),
            MyButton(
              onTap: postProduct,
              text: 'Post Product:',
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {IconData? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyTextField(
          controller: controller,
          hintText: hintText,
          obscureText: false,
          prefixIcon: prefixIcon,
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: selectedDeliveryMethod,
          onChanged: (String? value) {
            if (value != null) {
              // Ensure that the value is not null before calling updateDeliveryMethod
              updateDeliveryMethod(value);
            }
          },
          items: ['Delivery', 'Meetup']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}