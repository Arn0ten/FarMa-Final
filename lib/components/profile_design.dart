import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/product.dart';
import '../pages/edit_product_page.dart';
import '../pages/product_details_page.dart';
import '../services/auth/auth_gate.dart';
import '../services/auth/auth_service.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../pages/checkout_page.dart';
import '../pages/orders_page.dart';
import '../services/product/product_service.dart';

class ProfileDesign {
  static Widget buildProfilePage({
    required BuildContext context,
    required Map<String, dynamic> userData,
    required Function signOut,
    required Stream<List<Product>> userProducts,
    required VoidCallback pickImage,
    required String imagePath,
    required VoidCallback uploadImage,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(
                onTap: () {
                  _showProfilePicture(context, imagePath);
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: StreamBuilder<String?>(
                      stream: AuthService().getUserProfileImageURLStream(
                          AuthService().getCurrentUserId() ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return _buildProfileImage(snapshot.data!);
                        } else {
                          return _buildDefaultProfileIcon();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 198,
                child: GestureDetector(
                  onTap: pickImage,
                  child: Icon(
                    Icons.camera_alt,
                    size: 24,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              userData['fullName'],
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(height: 30),
          _buildExpansionTile('My details', [
            _buildDetailCardEditable(
              'Email',
              userData['email'],
              IconlyLight.message,
              () {
                _showEditDialog(context, 'Email', userData['email'],
                    (newValue) async {
                  final userId = AuthService().getCurrentUserId();
                  if (userId != null) {
                    await AuthService()
                        .updateUserEmail(userId, newValue as int);
                  }
                });
              },
            ),
            _buildDetailCardEditable(
              'Full Name',
              userData['fullName'],
              IconlyLight.user2,
              () {
                _showEditDialog(context, 'Full Name', userData['fullName'],
                    (newValue) async {
                  final userId = AuthService().getCurrentUserId();
                  if (userId != null) {
                    await AuthService()
                        .updateUserFullName(userId, newValue as int);
                  }
                });
              },
            ),
            _buildDetailCardEditable(
              'Age',
              userData['age'].toString(),
              IconlyLight.calendar,
              () {
                _showEditDialog(context, 'Age', userData['age'].toString(),
                    (newValue) async {
                  final userId = AuthService().getCurrentUserId();
                  if (userId != null) {
                    await AuthService()
                        .updateUserAge(userId, int.parse(newValue));
                  }
                });
              },
            ),
            _buildDetailCardEditable(
              'Address',
              userData['address'],
              IconlyLight.location,
              () {
                _showEditDialog(context, 'Address', userData['address'],
                    (newValue) async {
                  final userId = AuthService().getCurrentUserId();
                  if (userId != null) {
                    await AuthService().updateUserAddress(userId, newValue);
                  }
                });
              },
            ),
            _buildDetailCardEditable(
              'Contact Number',
              userData['contactNumber'].toString(),
              IconlyLight.call,
              () {
                _showEditDialog(context, 'Contact Number',
                    userData['contactNumber'].toString(), (newValue) async {
                  final userId = AuthService().getCurrentUserId();
                  if (userId != null) {
                    await AuthService()
                        .updateUserContactNumber(userId, int.parse(newValue));
                  }
                });
              },
            ),
          ]),
          const SizedBox(height: 30),
          _buildExpansionTile('My products', [
            StreamBuilder<List<Product>>(
              stream: userProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                        snapshot.data![index],
                        () {
                          // Edit callback
                          _navigateToEditProductPage(
                              context, snapshot.data![index]);
                        },
                        () {
                          // Delete callback
                          _showDeleteConfirmationDialog(
                              context, snapshot.data![index]);
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: Text('No products posted yet.'),
                );
              },
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context, signOut);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      children: children,
    );
  }

  static Widget _buildDetailCard(
      String title, String value, IconData iconData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.green,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }

  static Widget _buildProductCard(
      Product product, VoidCallback editCallback, VoidCallback deleteCallback) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
      child: Container(
        constraints: BoxConstraints(maxHeight: 500),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product.image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Error loading image');
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \₱${product.price?.toString() ?? 'N/A'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    editCallback();
                  } else if (value == 'delete') {
                    deleteCallback();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProfileImage(String imagePath) {
    return imagePath.isEmpty
        ? const Icon(
            Icons.account_circle,
            size: 120,
            color: Colors.grey,
          )
        : ClipOval(
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          );
  }

  static Widget _buildDefaultProfileIcon() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.account_circle,
        size: 120,
        color: Colors.grey,
      ),
    );
  }

  static void _pickAndUploadImage(
    VoidCallback pickImage,
    BuildContext context,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickImage();

      try {
        await AuthService().uploadProfileImage(File(pickedFile.path));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile image uploaded successfully.'),
          ),
        );
      } catch (e) {
        print('Error uploading profile image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading profile image: $e'),
          ),
        );
      }
    }
  }

  static void _updateProfileImage(File imageFile) {}

  static void _showProfilePicture(BuildContext context, String imagePath) {
    if (imagePath.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ClipOval(
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }
  }

  static void _showLogoutDialog(BuildContext context, Function signOut) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: 'Logout',
      desc: 'Are you sure you want to logout?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthGate(),
          ),
        );
      },
    )..show();
  }

  static void _navigateToEditProductPage(
      BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  static void _showDeleteConfirmationDialog(
      BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                //   logic to delete the product
                ProductService().deleteProduct(product.id);

                // Close the dialog
                Navigator.pop(context);

                // Show a Snackbar indicating success
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully.'),
                  ),
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildDetailCardEditable(
    String title,
    String value,
    IconData iconData,
    VoidCallback onEdit,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.green,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  static void _showEditDialog(BuildContext context, String title,
      String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the onSave callback
                String newValue = controller.text;
                onSave(newValue);

                // Close the dialog
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title updated successfully to $newValue'),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
