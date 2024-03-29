import 'package:flutter/material.dart';
import 'package:agriplant/widgets/product_card.dart';
import '../../models/product.dart';
import '../../services/product/product_service.dart';
import 'edit_product_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Product> searchResults;
  late List<Product> allProducts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    searchResults = [];
    initializeProducts();
  }

  Future<void> initializeProducts() async {
    try {
      allProducts = await ProductService().getProducts();
      allProducts.shuffle();
      updateSearchResults();
    } catch (error) {
      print('Error fetching all products: $error');
    }
  }

  void updateSearchResults() {
    searchProducts(_searchController.text);
  }

  void searchProducts(String query) {
    List<Product> filteredResults = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    print("Filtered Results: $filteredResults");

    setState(() {
      searchResults = filteredResults.isNotEmpty ? filteredResults : [];

      if (filteredResults.isEmpty && query.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No results found for "$query"'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            _buildSearchField(_searchController, searchProducts),
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

  void _navigateToEditProductPage(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(product);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) async {
    try {
      await ProductService().deleteProduct(product.id);

      setState(() {
        searchResults.remove(product);
      });
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  Widget _buildSearchField(
    TextEditingController searchController,
    Function(String) searchFunction,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search for products...",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            searchFunction(value);
          },
        ),
      ),
    );
  }

  Widget _buildExploreSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Explore Products",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<Product> searchResults, BuildContext context) {
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
                actions: [],
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

  Widget _buildNoResultsText() {
    return Text(
      'No results found',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }
}
