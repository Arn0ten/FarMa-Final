import 'dart:math';
import 'package:agriplant/widgets/order_item.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';  // Import the Product class

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Processing", "Picking", "Shipping", "Delivered"];

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My orders"),
          bottom: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: List.generate(tabs.length, (index) {
              return Tab(
                text: "${tabs[index]} ${Random().nextInt(10)}",
              );
            }),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            tabs.length,
                (index) {
              // Assuming you have a list of orders for each tab
              final List<Order> orders = getOrdersForTab(index);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(
                  orders.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OrderItem(order: orders[index]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Replace this function with your actual data source
  List<Order> getOrdersForTab(int tabIndex) {
    // TODO: Implement logic to get orders based on the tab index
    return [];
  }
}
