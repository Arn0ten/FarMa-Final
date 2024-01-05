import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class ChatBubble extends StatelessWidget {
  final String senderEmail;
  final String message;
  final bool isSender;
  final String senderProfileImageURL;
  final String senderUserId;

  const ChatBubble({
    Key? key,
    required this.senderEmail,
    required this.message,
    required this.isSender,
    required this.senderProfileImageURL,
    required this.senderUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Container for the sender's email and message
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isSender ? Colors.green : Colors.grey[300],
              borderRadius: isSender
                  ? BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(4.0), // Adjust this value as needed
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(4.0), // Adjust this value as needed
                bottomRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Display sender's email above their message
                if (!isSender)
                  Text(
                    senderEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.0), // Add spacing between message and profile image

          // Display sender's profile image as a CircleAvatar
          if (!isSender)
          // Inside StreamBuilder
            StreamBuilder<String?>(
              stream: AuthService().getUserProfileImageURLStream(senderUserId),
              builder: (context, snapshot) {
                print("Connection State: ${snapshot.connectionState}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print("Error fetching profile image: ${snapshot.error}");
                  return Text("Error fetching profile image");
                } else if (snapshot.hasData && snapshot.data != null) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data! + '?cache=${DateTime.now().millisecondsSinceEpoch}'),
                    radius: 16.0,
                  );
                } else {
                  print("Using DEFAULT_IMAGE_URL");
                  return CircleAvatar(
                    backgroundImage: NetworkImage('DEFAULT_IMAGE_URL'),
                    radius: 16.0,
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
