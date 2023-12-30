import 'package:flutter/material.dart';
import 'package:agriplant/widgets/cart_item.dart';
import '../services/cart/cart_service.dart';
import '../services/order/order_service.dart';
import '../widgets/designs/cart_page_design.dart';
import '../widgets/order_item.dart';
import '../models/product.dart'; // Import the Product class
import '../models/order.dart' as LocalOrder;
import 'checkout_page.dart'; // Import your local Order class and use an alias

// ... imports

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartPageDesign _cartPageDesign;

  @override
  void initState() {
    super.initState();
    _cartPageDesign = CartPageDesign(
      ordersStream: OrderService().getOrdersStream(),
      cartItems: CartService().getCartItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cartPageDesign.build(context);
  }
}





