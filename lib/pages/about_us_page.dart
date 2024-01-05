// about_page.dart

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FarMa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Farma Description: Connecting Farmers and Consumers\n\n'
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
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
        
              SizedBox(height: 24),
              Text(
                'Developer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Arneabell Bautista',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Contact',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Email: a.bautista.129340.tc@umindanao.edu.ph\nPhone: 09458938376',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Version',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
