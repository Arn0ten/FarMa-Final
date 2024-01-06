import 'package:flutter/material.dart';
import '../widgets/designs/about_us_page_design.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: AboutPageContent(),
      ),
    );
  }
}
