import 'dart:async';
import 'package:agriplant/widgets/chat_bubble.dart';
import 'package:agriplant/components/my_textfield.dart';
import 'package:agriplant/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruserID;

  const ChatPage({
    Key? key,
    required this.receiveruserEmail,
    required this.receiveruserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _newMessageController =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _chatService.addListener(() {
      _newMessageController.add(true);
    });
  }

  @override
  void dispose() {
    _newMessageController.close();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiveruserID,
        _messageController.text,
      );
      setState(() {
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.receiveruserEmail;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiveruserID,
        _firebaseAuth.currentUser?.uid ?? '',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        if (snapshot.hasData) {
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return const SizedBox();
    }

    var isSender = data['senderId'] == _firebaseAuth.currentUser?.uid;
    String senderEmail = data['senderEmail'];
    String senderUserId = data['senderId'];
    Timestamp timestamp = data['timestamp'];

    return StreamBuilder<String?>(
      stream: AuthService().getUserProfileImageURLStream(senderUserId),
      builder: (context, snapshot) {
        String senderProfileImageURL = snapshot.data ?? 'DEFAULT_IMAGE_URL';

        return ChatBubble(
          senderEmail: senderEmail,
          message: data['message'],
          isSender: isSender,
          senderProfileImageURL: senderProfileImageURL,
          senderUserId: senderUserId,
          timestamp: timestamp,
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                      size: 28.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
