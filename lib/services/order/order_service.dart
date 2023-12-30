import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart' as LocalOrder; // Import your local Order class
import '../../models/product.dart';

class OrderService {

  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  Future<void> placeOrder(List<Product> products) async {
    // Implement your logic for placing an order, e.g., sending the order to a server
    // You might want to create an order object and send it to your backend
    // For simplicity, let's print the order details here

    print('Placing order with the following products:');
    for (var product in products) {
      print('- ${product.name}, Quantity: ${product.quantity}');
    }

    // Add your logic for handling the order placement, such as sending it to a server
    // ...

    // For the sake of this example, let's simulate a delay (you might remove this in a real implementation)
    await Future.delayed(Duration(seconds: 2));

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

// Fetch orders from Firestore using the OrderService
Stream<List<LocalOrder.Order>> ordersStream = OrderService().getOrdersStream();
