import 'package:agriplant/pages/bookmark_page.dart';
import 'package:agriplant/pages/cart_page.dart';
import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/product_post_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/widgets/drawer/drawer_content.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chat/chat_service.dart';
import 'message_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userFullName = '';
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _chatService = ChatService();
    _listenToUnreadMessages();
  }

  void _listenToUnreadMessages() {
    _chatService.addListener(() {
      print('Unread messages count changed: ${_chatService.unreadMessageCount}');
      setState(() {});
    });
  }



  Future<void> loadUserData() async {
    try {
      final userDocument = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.user.email)
          .get();

      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('fullName')) {
          setState(() {
            userFullName = userData['fullName'];
          });
        } else {
          print('User data is missing full name.');
        }
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print("Error loading user data: $error");
    }
  }

  final pages = [
    ExplorePage(),
    BookmarkPage(),
    CartPage(),
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(),
      BookmarkPage(),
      ProductPostPage(),
      CartPage(),
      ProfilePage(userFullName: userFullName),
      // Pass userFullName to ProfilePage
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerContent(userName: userFullName),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, $userFullName!",
              style: GoogleFonts.bebasNeue(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              "Enjoy our services",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(),
                  ),
                );
              },
              icon: badges.Badge(
                badgeContent: Text(
                  '${_chatService.unreadMessageCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: Icon(IconlyBroken.chat),
              ),


            ),
          ),

        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) {
          if (index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPostPage(),
              ),
            );
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bookmark),
            label: "Bookmarks",
            activeIcon: Icon(IconlyBold.bookmark),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconlyLight.plus,
              size: 40,
            ),
            label: "Post",
            activeIcon: Icon(
              IconlyBold.plus,
              size: 40,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.buy),
            label: "Cart",
            activeIcon: Icon(IconlyBold.buy),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: "Profile",
            activeIcon: Icon(IconlyBold.profile),
          ),
        ],
      ),
    );
  }
}
