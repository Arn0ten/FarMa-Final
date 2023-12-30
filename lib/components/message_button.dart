import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../pages/chat_page.dart';

class MessageButton extends StatelessWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final VoidCallback? onMessagePressed;

  const MessageButton({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserId,
    this.onMessagePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (onMessagePressed != null) {
          onMessagePressed!();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatPage(
                receiveruserEmail: receiverUserEmail,
                receiveruserID: receiverUserId,
              ),
            ),
          );
        }
      },
      icon: const Icon(IconlyLight.chat),
      label: const Text("Message"),
    );
  }
}
