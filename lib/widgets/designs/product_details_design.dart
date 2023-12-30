import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../components/message_button.dart';
import '../../models/product.dart';
import '../../pages/product_details_page.dart';
import '../../services/cart/cart_service.dart';
import '../../services/product/product_service.dart';

class ProductDetailsDesign extends StatefulWidget {
  final Product product;
  final bool showMore;
  final TapGestureRecognizer readMoreGestureRecognizer;
  final VoidCallback addToCart;
  final bool addingToCart;

  final String receiverUserEmail;
  final String receiverUserId;

  const ProductDetailsDesign({
    Key? key,
    required this.product,
    required this.showMore,
    required this.readMoreGestureRecognizer,
    required this.addToCart,
    required this.addingToCart,
    required this.receiverUserEmail,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  State<ProductDetailsDesign> createState() => _ProductDetailsDesignState();
}

class _ProductDetailsDesignState extends State<ProductDetailsDesign> {
  int quantity = 1; // Default quantity

  void _handleMessageButtonPress() {
    if (widget.receiverUserEmail.isNotEmpty &&
        widget.receiverUserId.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MessageButton(
            receiverUserEmail: widget.receiverUserEmail,
            receiverUserId: widget.receiverUserId,
          ),
        ),
      );
    } else {
      print("Cannot open chat. Missing user details.");
    }
  }

  void _addToCart() {
    // Show a confirmation dialog using AwesomeDialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Confirm',
      desc: 'Do you want to add ${widget.product.name} to the cart?',
      btnCancelOnPress: () {
        // User pressed Cancel
      },
      btnOkOnPress: () {
        // User pressed Proceed
        _processAddToCart(); // Proceed with adding to cart
      },
    )..show();
  }
  void _processAddToCart() {
    // Pass the selected product and quantity to the CartService
    CartService().addToCart(widget.product, quantity);

    // Show a Snackbar indicating the progress
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Succesfully added ${quantity} ${widget.product.name} to the cart.'),
        duration: Duration(seconds: 2),
      ),
    );

    // Optionally, you can perform other actions here

    // Close the Snackbar after a delay
    Future.delayed(Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.product.name),
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Product Image
              Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Product Name
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              // Posted by User
              Text(
                "Posted by: ${widget.product.postedByUser.email}",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Stock and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "In Stock",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\₱${widget.product.price}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        TextSpan(
                          text: "/${widget.product.unit}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Description Section
              Text(
                "Description:",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text: widget.showMore
                            ? widget.product.description
                            : widget.product.description.length > 100
                            ? '${widget.product.description.substring(0, 100)}...'
                            : widget.product.description,
                      ),
                      if (widget.product.description.length > 100)
                        TextSpan(
                          recognizer: widget.readMoreGestureRecognizer,
                          text: widget.showMore ? " Read less" : " Read more",
                          style: TextStyle(
                            color:
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quantity Section
              Row(
                children: [
                  Text(
                    "Quantity: ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          "$quantity",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Similar Products Section
              Text(
                "Similar Products: ",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: ProductService().fetchSimilarProducts(widget.product),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return Text('No similar products found.');
                    } else {
                      List<Product> similarProducts = snapshot.data!;
                      return ListView.builder(
                        itemCount: similarProducts.length,
                        itemBuilder: (context, index) {
                          Product similarProduct = similarProducts[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsDesign(
                                    product: similarProduct,
                                    showMore: false,
                                    readMoreGestureRecognizer:
                                    TapGestureRecognizer(),
                                    addToCart: () {},
                                    addingToCart: false,
                                    receiverUserEmail: "",
                                    receiverUserId: "",
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                NetworkImage(similarProduct.image),
                              ),
                              title: Text(similarProduct.name,
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Price: \₱${similarProduct.price.toStringAsFixed(2)}'),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Message Button Section
              MessageButton(
                receiverUserEmail: widget.receiverUserEmail,
                receiverUserId: widget.receiverUserId,
              ),
              const SizedBox(height: 20),

              // Add to Cart Button
              ElevatedButton.icon(
                onPressed: widget.addingToCart ? null : _addToCart,
                icon: const Icon(IconlyLight.bag2),
                label: widget.addingToCart
                    ? const CircularProgressIndicator()
                    : const Text("Add to Cart"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
          if (widget.addingToCart)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
