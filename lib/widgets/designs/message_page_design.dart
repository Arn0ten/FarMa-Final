import 'package:agriplant/components/user_tile.dart';
import 'package:agriplant/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagePageDesign {
  static ThemeData themeData = ThemeData(
    primarySwatch: Colors.green,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
    ),
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Messages'),
    );
  }

  Widget buildUserList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return const Text('Error');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildUserListItem(context, snapshot.data!.docs[index]);
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Display all registered users except the current user
    if (_auth.currentUser!.uid != data['uid']) {
      return ListTile(
        leading: CircleAvatar(
          // You can replace this with the user's profile picture
          backgroundColor: Colors.green,
          child: Text(data['fullName'][0]),
        ),
        title: Text(data['fullName']),
        subtitle: const Text('...'), // You can replace this with the last message
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserEmail: data['email'],
                receiveruserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Exclude the current user from the list
    }
  }
}