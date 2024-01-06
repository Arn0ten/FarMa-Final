import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bookmark_card.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: _buildBookmarkList(),
    );
  }

  Widget _buildBookmarkList() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text('Please log in to view bookmarks.'),
      );
    }

    return Center(
      child: StreamBuilder(
        key: UniqueKey(),
        stream: FirebaseFirestore.instance
            .collection('bookmarks')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching bookmarks: ${snapshot.error}'),
            );
          }

          List<String> bookmarkedProductIds = snapshot.data!.docs
              .map((doc) => doc['productId'] as String)
              .toList();

          if (bookmarkedProductIds.isEmpty) {
            return Center(
              child: Text('You have no bookmarks.'),
            );
          }

          return GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: bookmarkedProductIds.length,
            itemBuilder: (context, index) {
              return BookmarkProductCard(
                productId: bookmarkedProductIds[index],
              );
            },
          );
        },
      ),
    );
  }
}
