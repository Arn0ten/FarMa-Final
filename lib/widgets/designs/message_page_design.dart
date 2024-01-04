import 'package:agriplant/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/chat/chat_service.dart';

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
    if (data['uid'] != null && _auth.currentUser!.uid != data['uid']) {
      return FutureBuilder<String>(
        future: ChatService().getLastMessageText(data['uid'], _auth.currentUser!.uid),
        builder: (context, snapshot) {
          String lastMessage = snapshot.data ?? 'No messages yet';

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: StreamBuilder<String?>(
              stream: AuthService().getUserProfileImageURLStream(data['uid']), // Pass user's UID
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return CircleAvatar(
                    backgroundColor: Colors.green,
                    backgroundImage: NetworkImage(snapshot.data!),
                    // Add additional properties or adjustments if needed
                  );
                } else {
                  // If no profile image is available, show a default CircleAvatar
                  return CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(data['fullName'][0]),
                  );
                }
              },
            ),
            title: Text(
              data['fullName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              lastMessage,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
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
        },
      );
    } else {
      return Container(); // Exclude the current user from the list
    }
  }
}
