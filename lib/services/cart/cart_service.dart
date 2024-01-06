import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() => _instance;

  CartService._internal();

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Product> cartItems = [];

  String get currentUserUid => _auth.currentUser?.uid ?? "";

  String get cartId => 'cart_${currentUserUid}';
  static const String cartKey = 'cart';

  void addToCart(Product product, int quantity) {
    product.cartId = cartId;
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cartItems[index].quantity += quantity;
    } else {
      product.quantity = quantity;
      cartItems.add(product);
    }
  }

  void removeFromCart(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  List<Product> getCartItems() {
    return cartItems.where((item) => item.cartId == cartId).toList();
  }

  void increaseQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cartItems[index].quantity += 1;
    }
  }

  void decreaseQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity -= 1;
    }
  }

  void clearCart() {
    cartItems.removeWhere((item) => item.cartId == cartId);
  }
}
