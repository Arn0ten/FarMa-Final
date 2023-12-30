import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/product.dart';
import '../components/circle_avatar_with_icon.dart';
import '../components/text_box.dart';
import '../pages/checkout_page.dart';
import '../pages/orders_page.dart';
import '../services/auth/auth_gate.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileDesign {
  static Widget buildProfilePage({
    required BuildContext context,
    required Map<String, dynamic> userData,
    required Function signOut,
    required Stream<List<Product>> userProducts,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatarWithIcon(
            icon: IconlyLight.profile,
            backgroundColor: Colors.white30,
          ),
          Center(
            child: Text(
              userData['fullName'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 30,),

          // Expandable "My details" section
          ExpansionTile(
            title: const Text(
              'My details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            children: [
              _buildDetailCard('Email', userData['email'], IconlyLight.message),
              _buildDetailCard('Full Name', userData['fullName'], IconlyLight.user2),
              _buildDetailCard('Age', userData['age'].toString(), IconlyLight.calendar),
              _buildDetailCard('Address', userData['address'], IconlyLight.location),
              _buildDetailCard('Contact Number', userData['contactNumber'].toString(), IconlyLight.call),
            ],
          ),

          const SizedBox(height: 20),

          // "My Products" section
          ExpansionTile(
            title: const Text(
              'My Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            children: [
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
                        return _buildProductCard(snapshot.data![index]);
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
            ],
          ),

          // Logout button outside of the scrollable list
          // Checkout button outside of the scrollable list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
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

  static Widget _buildDetailCard(String title, String value, IconData iconData) {
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

  static Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            Text('Price: \₱${product.price.toString()}'),
            // Add other details you want to display
          ],
        ),
      ),
    );
  }

}
