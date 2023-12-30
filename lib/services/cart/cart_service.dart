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

  // Generate a unique cart ID based on the user's UID
  String get cartId => 'cart_${currentUserUid}';

  void addToCart(Product product, int quantity) {
    print("Adding to cart in CartService: ${product.name}");
    // Set the cartId for the product
    product.cartId = cartId;

    // Check if the product is already in the cart
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      // If the product is already in the cart, increase the quantity
      cartItems[index].quantity += quantity;
    } else {
      // If the product is not in the cart, add it with the specified quantity
      product.quantity = quantity;
      cartItems.add(product);
    }
    print("Added to cart in CartService successfully");
  }

  void removeFromCart(Product product) {
    print("Removing from cart in CartService: ${product.name}");
    // Check if the product is in the cart
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      // If the product is in the cart, decrease the quantity
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // If the quantity is 1, remove the product from the cart
        cartItems.removeAt(index);
      }
    }
    print("Removed from cart in CartService successfully");
  }

  List<Product> getCartItems() {
    // Use the cartId to filter cart items
    // You may want to replace this with your actual logic to fetch items from a database
    // For now, we are returning a copy of cartItems filtered by the cartId
    return cartItems.where((item) => item.cartId == cartId).toList();
  }

  void increaseQuantity(Product product) {
    // Check if the product is in the cart
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      // If the product is in the cart, increase the quantity
      cartItems[index].quantity += 1;
    }
  }

  void decreaseQuantity(Product product) {
    // Check if the product is in the cart
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1 && cartItems[index].quantity > 1) {
      // If the product is in the cart and the quantity is more than 1, decrease the quantity
      cartItems[index].quantity -= 1;
    }
  }

  void clearCart() {
    // Clear the cart associated with the current user
    cartItems.removeWhere((item) => item.cartId == cartId);
  }

}
