import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime date;
  

  Order({
    required this.id,
    required this.products,
    required this.date,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      products: List<Product>.from(map['products']
          .map((productMap) => Product.fromMap(productMap))),
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((product) => product.toMap()).toList(),
      'date': date,
    };
  }
}
