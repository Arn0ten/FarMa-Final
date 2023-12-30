import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../models/product.dart';
import '../../services/cart/cart_service.dart';
import '../cart_item.dart';

class CheckoutPageDesign {
  final List<Product> checkoutItems;

  CheckoutPageDesign({required this.checkoutItems});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildCheckoutItems(),
                const SizedBox(height: 20),
                _buildTotal(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPlaceOrderButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Checkout Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (checkoutItems.isNotEmpty)
          ...checkoutItems.map(
                (product) => CartItem(cartItem: product),
          )
        else
          const Text("No items in the checkout"),
      ],
    );
  }

  Widget _buildTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total: \₱${calculateTotal(checkoutItems)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    final bool hasItemsInCheckout = checkoutItems.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: InkWell(
        onTap: hasItemsInCheckout ? () => _confirmPlaceOrder(context) : null,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: hasItemsInCheckout ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

  Future<void> _confirmPlaceOrder(BuildContext context) async {
    // Show a confirmation dialog using AwesomeDialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: 'Confirm Order',
      desc: 'Are you sure you want to place this order?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _placeOrder(context);
      },
    )..show();
  }

  Future<void> _placeOrder(BuildContext context) async {
    try {
      // Implement the logic to place the order or perform other checkout actions
      // For example, you can call a method in OrderService to place the order.
      // await OrderService().placeOrder(checkoutItems);

      // Optionally, you can clear the cart after placing the order
      CartService().clearCart();

      // Show a SnackBar to notify that checkout was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
        ),
      );

      // Optionally, you can navigate to a success page or perform any other action
    } catch (e) {
      // Handle the error (e.g., show an error message)
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error placing order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String calculateTotal(List<Product> items) {
    // Calculate the total amount based on the checkout items
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total.toStringAsFixed(2);
  }

