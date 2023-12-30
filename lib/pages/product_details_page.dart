import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../models/product.dart';
import '../services/cart/cart_service.dart';
import '../widgets/designs/product_details_design.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _bookmarksCollection =
  FirebaseFirestore.instance.collection('bookmarks');
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;
  bool addingToCart = false; // Track whether the product is being added to the cart
  bool isBookmarked = false; // Variable to track bookmark status
  int quantity = 1;

  void addToCart() {
    // Set state to trigger UI changes and show loading indicator
    setState(() {
      addingToCart = true;
    });

    // Add the product to the cart with the current quantity
    CartService().addToCart(widget.product, quantity);

    // Simulate a delay to show the loading indicator
    Future.delayed(const Duration(seconds: 2), () {
      // Reset addingToCart after the delay
      setState(() {
        addingToCart = false;
        // Display a snackbar message when the product is added to the cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to cart'),
            duration: Duration(seconds: 1),
          ),
        );
        // Toggle the bookmark status after adding to the cart
        toggleBookmark();
      });
    });
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

          // Show AwesomeDialog
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            title: 'Bookmark Removed',
            desc: 'Product has been removed from bookmarks.',
            btnOkText: 'OK', // Add the OK button
            btnOkOnPress: () {}, // Add the action for the OK button
          )..show();
        } else {
          // Add bookmark
          await _bookmarksCollection.add({
            'productId': widget.product.id,
            'userId': currentUser.uid,
          });

          // Show AwesomeDialog
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            title: 'Bookmark Added',
            desc: 'Product has been added to bookmarks.',
            btnOkText: 'OK', // Add the OK button
            btnOkOnPress: () {}, // Add the action for the OK button
          )..show();
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

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductDetailsDesign(
        product: widget.product,
        showMore: showMore,
        readMoreGestureRecognizer: readMoreGestureRecognizer,
        addToCart: addToCart,
        addingToCart: addingToCart,
        receiverUserEmail: widget.product.postedByUser.email,
        receiverUserId: widget.product.postedByUser.uid,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Details"),
      actions: [
        // Inside ProductDetailsPage build method
        StreamBuilder(
          stream: _bookmarksCollection
              .where('productId', isEqualTo: widget.product.id)
              .where('userId', isEqualTo: _auth.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            bool isBookmarked =
                snapshot.hasData && snapshot.data!.docs.isNotEmpty;

            return IconButton(
              onPressed: () {
                toggleBookmark();
              },
              iconSize: 18,
              icon: isBookmarked
                  ? const Icon(IconlyBold.bookmark)
                  : const Icon(IconlyLight.bookmark),
            );
          },
        ),
      ],
    );
  }
}
