import 'package:agriplant/components/user_tile.dart';
import 'package:agriplant/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';

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

    // Ensure data['uid'] is not null before using it
    if (data['uid'] != null && _auth.currentUser!.uid != data['uid']) {
      return ListTile(
        leading: StreamBuilder<String?>(
          stream: AuthService().getUserProfileImageURLStream(data['uid']),
          builder: (context, snapshot) {
            return CircleAvatar(
              backgroundColor: Colors.green,
              child: snapshot.hasData && snapshot.data != null
                  ? ClipOval(
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: 36, // Adjust size as needed
                  height: 36, // Adjust size as needed
                ),
              )
                  : Text(data['fullName'][0]),
            );
          },
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
      return Container(); // Exclude the current user or user with null UID from the list
    }
  }
}