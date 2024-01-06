import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../models/product.dart';
import '../../pages/order_succes_page.dart';
import '../../services/cart/cart_service.dart';
import '../cart_item.dart';

class CheckoutPageDesign {
  final List<Product> checkoutItems;
  final BuildContext context;

  CheckoutPageDesign({required this.checkoutItems, required this.context});

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
            (product) =>
                CartItem(cartItem: product, removeFromCart: _removeFromCart),
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

  Future<void> _confirmPlaceOrder(BuildContext context) async {
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
      CartService().clearCart();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessPage(),
        ),
      );
    } catch (e) {
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
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total.toStringAsFixed(2);
  }

  void _removeFromCart(Product product) {
    try {
      CartService().removeFromCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item removed from cart'),
        ),
      );
    } catch (e) {
      print('Error removing item from cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Error removing item from cart. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
