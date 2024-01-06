import 'package:flutter/material.dart';
import 'package:agriplant/widgets/cart_item.dart';
import '../services/cart/cart_service.dart';
import '../services/order/order_service.dart';
import '../widgets/designs/cart_page_design.dart';
import '../widgets/order_item.dart';
import '../models/product.dart';
import '../models/order.dart' as LocalOrder;
import 'checkout_page.dart';

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
      context: context, // Pass the context here
      ordersStream: OrderService().getOrdersStream(),
      cartItems: CartService().getCartItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cartPageDesign.build(context);
  }
}
