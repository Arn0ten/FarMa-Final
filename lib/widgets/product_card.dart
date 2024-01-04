import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../models/product.dart';
import '../pages/product_details_page.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.actions,
  }) : super(key: key);

  final Product product;
  final List<Widget> actions;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _bookmarksCollection =
  FirebaseFirestore.instance.collection('bookmarks');
  late bool isBookmarked = false; // Initialize with false
  bool _mounted = false; // Add this line to track mounted state

  @override
  void initState() {
    super.initState();
    _mounted = true; // Set to true when the widget is mounted
    // Initialize isBookmarked based on the stored bookmark status
    initBookmarkStatus();
  }

  Future<void> initBookmarkStatus() async {
    if (!mounted) return; // Check mounted state before setState

    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        // Check if the current product is bookmarked by the user
        var snapshot = await _bookmarksCollection
            .where('productId', isEqualTo: widget.product.id)
            .where('userId', isEqualTo: currentUser.uid)
            .get();

        if (mounted) {
          // Check mounted before calling setState
          setState(() {
            isBookmarked = snapshot.docs.isNotEmpty;
          });
        }
      } catch (error) {
        if (mounted) {
          // Check mounted before calling setState
          print('Error initializing bookmark status: $error');
        }
      }
    } else {
      // Handle the case when the user is not authenticated
      if (mounted) {
        // Check mounted before calling setState
        print('User is not authenticated.');
      }
    }
  }

  @override
  void dispose() {
    _mounted = false; // Set to false when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: widget.product),
          ),
        );
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    widget.product.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₱${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product.deliveryMethod ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),

                            ],
                          ),
                        ),
                        ...widget.actions, // Add this line
                        IconButton(
                          onPressed: toggleBookmark,
                          iconSize: 18,
                          icon: isBookmarked
                              ? const Icon(IconlyBold.bookmark)
                              : const Icon(IconlyLight.bookmark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Assume it's a network image
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      // Assume it's a local asset
      return AssetImage(imagePath);
    } else {
      // Assuming imagePath is a local cache path
      // Modify this part based on your actual path structure
      String relativePath = imagePath.split('/cache/').last;
      return AssetImage(relativePath);
    }
  }

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    _toggleBookmark(!isBookmarked);
  }

  Future<void> _toggleBookmark(bool isBookmarked) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        if (isBookmarked) {
          // Remove bookmark
          await _bookmarksCollection
              .where('productId', isEqualTo: widget.product.id)
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
              duration: Duration(seconds: 2), // Adjust the duration as needed
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        } else {
          // Add bookmark
          await _bookmarksCollection.add({
            'productId': widget.product.id,
            'userId': currentUser.uid,
          });

          // Show SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bookmark Added'),
              duration: Duration(seconds: 2), // Adjust the duration as needed
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (error) {
        print('Error toggling bookmark: $error');
        // Handle the error as needed
      }
    } else {
      // Handle the case when the user is not authenticated
      print('User is not authenticated.');
    }
  }
}