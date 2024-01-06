import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/auth/auth_service.dart';

class ChatBubble extends StatelessWidget {
  final String senderEmail;
  final String message;
  final bool isSender;
  final String senderProfileImageURL;
  final String senderUserId;
  final Timestamp timestamp; // Add timestamp property

  const ChatBubble({
    Key? key,
    required this.senderEmail,
    required this.message,
    required this.isSender,
    required this.senderProfileImageURL,
    required this.senderUserId,
    required this.timestamp, // Pass timestamp to ChatBubble
  }) : super(key: key);

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime); // Use DateFormat from intl package
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Container for the message and timestamp
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isSender ? Colors.green : Colors.grey[300],
              borderRadius: isSender
                  ? BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(4.0),
              ) // Adjust this value as needed
                  : BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 4.0), // Add spacing between message and timestamp
                Text(
                  _formatTimestamp(timestamp), // Format and display the timestamp
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ), // Add spacing between message and profile image
          // Display sender's profile image as a CircleAvatar
          if (!isSender)
          // Inside StreamBuilder
            SizedBox(
              child: StreamBuilder<String?>(
                stream: AuthService().getUserProfileImageURLStream(senderUserId),
                builder: (context, snapshot) {
                  print("Connection State: ${snapshot.connectionState}");
                  if (snapshot.hasError) {
                    print("Error fetching profile image: ${snapshot.error}");
                    return Text("Error fetching profile image");
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return CircleAvatar(
                      backgroundImage:
                      NetworkImage(snapshot.data! + '?cache=${DateTime.now().millisecondsSinceEpoch}'),
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
            ),
        ],
      ),
    );
  }

}

