import 'package:flutter/material.dart';
import 'package:agriplant/widgets/product_card.dart';
import '../../models/product.dart';

import '../../services/product/product_service.dart';

class ExplorePageDesign {
  static const double paddingValue = 16.0;
  static const double borderRadiusValue = 15.0;
  static const double fontSizeValue = 15.0;

  static Widget buildExplorePage(
      TextEditingController searchController,
      List<Product> searchResults,
      Stream<List<Product>>? searchResultsStream,
      BuildContext context,
      Function(String) searchFunction,
      ) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(paddingValue),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            _buildSearchField(searchController, searchFunction),
            SizedBox(height: 20),
            _buildExploreSection(context),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildProductGrid(searchResults, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSearchField(
      TextEditingController searchController, Function(String) searchFunction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingValue),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search for products...",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: searchFunction,
        ),
      ),
    );
  }

  static Widget _buildExploreSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Explore Products",
          style: TextStyle(
            fontSize: fontSizeValue,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  static Widget _buildProductGrid(List<Product> searchResults, BuildContext context) {
    return searchResults.isNotEmpty
        ? GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: searchResults[index],
          actions: [], // Add an empty list or provide actions as needed
        );
      },
    )
        : Center(
      child: searchResults.isEmpty
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      )
          : _buildNoResultsText(),
    );
  }

  static Widget _buildNoResultsText() {
    return Text(
      'No results found',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }

}