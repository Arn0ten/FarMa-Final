import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CircleAvatarWithIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  const CircleAvatarWithIcon({
    Key? key,
    required this.icon,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: 40,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}