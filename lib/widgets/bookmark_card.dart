import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../models/product.dart';
import '../pages/product_details_page.dart';

class BookmarkProductCard extends StatelessWidget {
  final String productId;

  const BookmarkProductCard({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<DocumentSnapshot>(
        future: productId.isNotEmpty
            ? FirebaseFirestore.instance.collection('products').doc(productId).get()
            : null,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Text('');
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: Product.fromMap(data)),
                ),
              );

            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(
                        image: _getImageProvider(data['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded( // Wrap the Column with Expanded
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₱${data['price']?.toStringAsFixed(2) ?? '0.00'}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeBookmark(context, productId),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _buildPopupMenuButton(BuildContext context, Map<String, dynamic> data) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handlePopupMenuSelection(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'removeBookmark', child: Text('Remove Bookmark')),
        // Add more options as needed
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  void _handlePopupMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'removeBookmark':
        _removeBookmark(context, productId);
        break;
    // Handle more options as needed
    }
  }

  ImageProvider<Object> _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      String relativePath = imagePath.split('/cache/').last;
      return AssetImage(relativePath);
    }
  }
  Future<void> _removeBookmark(BuildContext context, String productId) async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Remove bookmark
        await FirebaseFirestore.instance
            .collection('bookmarks')
            .where('productId', isEqualTo: productId)
            .where('userId', isEqualTo: currentUser.uid)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark Removed'),
            duration: Duration(seconds: 1),
          ),
        );

        print('Bookmark removed successfully.');
      } else {
        // Handle the case when the user is not authenticated
        print('User is not authenticated.');
      }
    } catch (error) {
      print('Error removing bookmark: $error');
      // Handle the error as needed
    }
  }
}
