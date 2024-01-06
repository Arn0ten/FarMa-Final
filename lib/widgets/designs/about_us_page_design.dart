import 'package:flutter/material.dart';

class AboutPageContent extends StatelessWidget {
  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('FarMa'),
          _sectionText( 'Farma Description: Connecting Farmers and Consumers\n\n'
              'Welcome to Farma, an innovative farm-to-table mobile application designed to bridge the gap between farmers and consumers. This app aims to revolutionize the way fresh produce reaches your table, fostering a direct connection between local farmers and conscious consumers.\n\n'
              'Key Features:\n\n'
              'Local Produce Marketplace:\n\n'
              'Explore a diverse range of locally sourced fruits, vegetables, and other farm-fresh products.\n'
              'Support local farmers by purchasing directly from their harvest.\n\n'
              'Transparent Supply Chain:\n\n'
              'Trace the journey of your food from the farm to your doorstep.\n'
              'Learn about the farmers, their sustainable practices, and the story behind each product.\n\n'
              'Seasonal Recommendations:\n\n'
              'Receive personalized recommendations based on seasonal availability.\n'
              'Discover new and exciting produce throughout the year.\n\n'
              'Order Customization:\n\n'
              'Tailor your orders to meet your preferences and dietary needs.\n'
              'Enjoy the flexibility of choosing the quantity and variety of products in each order.\n\n'
              'Educational Resources:\n\n'
              'Access valuable information about farming practices, sustainable agriculture, and the importance of supporting local growers.\n\n'
              'Why Farma?\n\n'
              'Empowering Local Farmers: Farma empowers local farmers by providing them with a direct platform to showcase and sell their products, eliminating the need for intermediaries.\n\n'
              'Freshness Guaranteed: With Farma, consumers can trust the freshness and quality of the products they receive, knowing exactly where their food comes from.\n\n'
              'Community Building: Join a community of like-minded individuals who share a passion for supporting local agriculture and promoting sustainable food choices.\n\n'
              'Join Farma today and embark on a journey to discover the true essence of farm-fresh goodness, right at your fingertips. Let\'s cultivate a healthier, more sustainable future together!',
          ),
          _sectionTitle('Developer'),
          _sectionText('Arneabell Bautista'),
          _sectionTitle('Contact'),
          _sectionText('Email: a.bautista.129340.tc@umindanao.edu.ph\nPhone: 09458938376'),
          _sectionTitle('Version'),
          _sectionText('1.0.0'),
        ],
      ),
    );
  }
}