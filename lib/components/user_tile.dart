import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String fullName;
  final VoidCallback onTap;

  const UserTile({
    Key? key,
    required this.fullName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fullName),
      onTap: onTap,
    );
  }
}
