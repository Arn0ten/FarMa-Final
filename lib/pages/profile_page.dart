import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/services/product/product_service.dart';
import 'package:agriplant/models/product.dart';

import '../components/profile_design.dart';
import '../services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required String userFullName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late ProductService _productService;

  final ImagePicker _imagePicker = ImagePicker();
  late String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      try {
        await Provider.of<AuthService>(context, listen: false)
            .uploadProfileImage(File(_imagePath!));

        String? newImageUrl =
            await Provider.of<AuthService>(context, listen: false)
                .getUserProfileImageURL();

        if (newImageUrl != null) {
          setState(() {
            _imagePath = newImageUrl;
          });
        } else {
          print('Error: Profile image URL is null after upload.');
        }
      } catch (e) {
        print('Error uploading profile image: $e');
      }
    }
  }

  void _showConfirmationDialog(VoidCallback action) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: 'Confirm Action',
      desc: 'Are you sure you want to proceed?',
      btnCancelOnPress: () {},
      btnOkOnPress: action,
    )..show();
  }

  Future<void> _pickAndUploadImage(bool isCamera) async {
    final pickedFile = await _imagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });

      _showConfirmationDialog(() {
        if (isCamera) {
          _uploadImage();
        } else {
          _uploadImage();
        }
      });
    }
  }

  Future<void> _showImageSourceModal() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadImage(true);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadImage(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            final userProductsStream =
                _productService.getUserProducts(currentUser.uid);

            return ProfileDesign.buildProfilePage(
              context: context,
              userData: userData,
              signOut: signOut,
              userProducts: userProductsStream,
              pickImage: () => _showImageSourceModal(),
              uploadImage: () => _pickAndUploadImage(true),
              imagePath: _imagePath,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
