import 'package:agriplant/pages/bookmark_page.dart';
import 'package:agriplant/pages/checkout_page.dart';
import 'package:agriplant/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class DrawerContent extends StatelessWidget {
  final String userName;

  const DrawerContent({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 30,
                  child: Text(
                    userName.isEmpty ? 'U' : userName[0],
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),const SizedBox(height: 10),
          ListTile(
            title: const Text("My orders"),
            leading: const Icon(IconlyLight.bag),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("My checkouts"),
            leading: const Icon(IconlyLight.bag2),
            onTap: () {
              // Assuming checkoutItems should be passed here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(checkoutItems: []),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Bookmarks"),
            leading: const Icon(IconlyLight.bookmark),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  BookmarkPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("About us"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
