import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart/cart_service.dart';
import '../widgets/cart_item.dart';
import '../widgets/designs/checkout_page_design.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product> checkoutItems;

  CheckoutPage({Key? key, required this.checkoutItems}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CheckoutPageDesign _checkoutPageDesign;

  @override
  void initState() {
    super.initState();
    _checkoutPageDesign = CheckoutPageDesign(checkoutItems: widget.checkoutItems);
  }

  @override
  Widget build(BuildContext context) {
    return _checkoutPageDesign.build(context);
  }
}
