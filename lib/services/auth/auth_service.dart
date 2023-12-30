import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      _firestore.collection('Farma Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String address,
      int age,
      int contactNumber,
      ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user's display name
      await _firebaseAuth.currentUser!.updateDisplayName(fullName);

      _firestore.collection('Farma Users').doc(fullName).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'fullName': fullName,
        'address': address,
        'age': age,
        'contactNumber': contactNumber,
      });

      await FirebaseFirestore.instance.collection("Users").doc(email).set({
        'email': email,
        'fullName': fullName.trim(),
        'address': address.trim(),
        'age': age,
        'contactNumber': contactNumber,
        'searchField': generateSearchField(fullName.trim()),
      });

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  String generateSearchField(String input) {
    return input.toLowerCase();
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> productsSnapshot =
      await _firestore.collection('Products').get();

      List<Map<String, dynamic>> products =
      productsSnapshot.docs.map((doc) => doc.data()).toList();

      return products;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (searchTerm.isEmpty) {
        return [];
      } else {
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection("Users")
            .where('fullName', isGreaterThanOrEqualTo: searchTerm)
            .where('fullName', isLessThan: searchTerm + 'z')
            .get();

        List<Map<String, dynamic>> results =
        snapshot.docs.map((doc) => doc.data()).toList();

        results.removeWhere((user) => user['uid'] == currentUserUid);
        return results;
      }
    } catch (e) {
      print("Error searching users: $e");
      return [];
    }
  }
}
