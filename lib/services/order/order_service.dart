import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart' as LocalOrder;
import '../../models/product.dart';

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> placeOrder(List<Product> products) async {
    final order = LocalOrder.Order(
      id: 'your_order_id',
      products: products,
      date: DateTime.now(),
    );

    final orderMap = order.toMap();

    await _ordersCollection.add(orderMap);

    print('Order placed successfully!');
  }

  Stream<List<LocalOrder.Order>> getOrdersStream() {
    return _ordersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LocalOrder.Order(
          id: doc.id,
          products: List<Product>.from(data['products']
              .map((productMap) => Product.fromMap(productMap))),
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}

Stream<List<LocalOrder.Order>> ordersStream = OrderService().getOrdersStream();
