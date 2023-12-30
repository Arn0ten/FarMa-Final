import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final Icon icon;
  final int notificationCount;

  NotificationIcon({
    required this.icon,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        icon,
        if (notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
            ),
          ),
      ],
    );
  }
}
