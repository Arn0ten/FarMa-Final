import 'package:flutter/material.dart';
import 'package:agriplant/widgets/product_card.dart';
import '../../models/product.dart';
import '../../pages/all_products_page.dart';
import '../../services/product/product_service.dart';

class ExplorePageDesign {
  static Widget buildExplorePage(
      TextEditingController searchController,
      List<Product> searchResults,
      Stream<List<Product>>? searchResultsStream,
      BuildContext context,
      Function(String) searchFunction,
      ) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white, // Set a light background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Light grey background
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search for products...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    searchFunction(value); // Call the search function
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore Products",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _navigateToAllProductsPage(context);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: searchResults.isNotEmpty
                    ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: searchResults[index]);
                  },
                )
                    : Center(
                  child: searchResults.isEmpty
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                      : Text(
                    '',

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _navigateToAllProductsPage(BuildContext context) {
    // Navigate to the page with all products
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllProductsPage()), // Replace with the actual page
    );
  }
}
