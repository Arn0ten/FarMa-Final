import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 2, right: 16,top: 2),
      margin: const EdgeInsets.only(left: 20, right: 20,top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey),
              ),
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.settings)),
            ],
          ),

          Text(text),
        ],
      ),
    );
  }
}
