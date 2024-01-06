import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> updateUserAge(String userId, int newAge) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'age': newAge});
    } catch (e) {
      print('Error updating user age: $e');
      throw e;
    }
  }

  Future<void> updateUserAddress(String userId, String newAddress) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'address': newAddress});
    } catch (e) {
      print('Error updating user address: $e');
      throw e;
    }
  }
  Future<void> updateUserEmail(String userId, int newEmail) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'email': newEmail});
    } catch (e) {
      print('Error updating user email: $e');
      throw e;
    }
  }
  Future<void> updateUserFullName(String userId, int newNewUserFullname) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'fullName': newNewUserFullname});
    } catch (e) {
      print('Error updating user fullname: $e');
      throw e;
    }
  }
  Future<void> updateUserContactNumber(String userId, int newContactNumber) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'contactNumber': newContactNumber});
    } catch (e) {
      print('Error updating user contact number: $e');
      throw e;
    }
  }


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
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (uid.isNotEmpty) {
        // 1. Get a reference to the storage location
        String imageId = DateTime.now().millisecondsSinceEpoch.toString();
        String imagePath = 'user_profile_images/$uid/$imageId.jpg';
        Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);

        // 2. Upload the file
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // 3. Handle the upload result or URL
        TaskSnapshot taskSnapshot = await uploadTask;
        if (taskSnapshot.state == TaskState.success) {
          String downloadUrl = await storageReference.getDownloadURL();

          // 4. Update user's profile with the new image URL
          await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);

          print('Profile image uploaded successfully. URL: $downloadUrl');
          // Update the user's profile image URL in Firestore
          await _firestore
              .collection('Farma Users')
              .doc(uid)
              .set({'photoURL': downloadUrl}, SetOptions(merge: true));

          return downloadUrl; // Return the download URL
        } else {
          throw ('Image upload failed');
        }
      } else {
        print('User is not authenticated.');
        throw ('User is not authenticated');
      }
    } catch (e) {
      // Handle errors during the image upload
      print('Error uploading profile image: $e');
      throw e; // Rethrow the exception if needed
    }
  }

  Future<String?> getUserProfileImageURL() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (uid.isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Check if the user has a photo URL
          if (currentUser.photoURL != null && currentUser.photoURL!.isNotEmpty) {
            return currentUser.photoURL;
          } else {
            // If the user does not have a photo URL, try fetching from Firestore
            DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('Farma Users').doc(uid).get();
            if (userSnapshot.exists) {
              Map<String, dynamic> userData = userSnapshot.data() ?? {};
              String? photoURL = userData['photoURL'];
              return photoURL;
            } else {
              // If no photoURL is found in Firestore, you may choose to return a default URL or handle it as needed
              return null;
            }
          }
        }
      }
      return null;
    } catch (e) {
      print('Error getting user profile image URL: $e');
      return null;
    }
  }
  Stream<String?> getUserProfileImageURLStream(String userId) {
    try {
      return FirebaseFirestore.instance
          .collection('Farma Users')
          .doc(userId)
          .snapshots()
          .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        // Check if the document exists
        if (snapshot.exists) {
          // Retrieve the user data and return the photoURL
          Map<String, dynamic> userData = snapshot.data() ?? {};
          return userData['photoURL'];
        } else {
          // Return null if the document does not exist
          return null;
        }
      });
    } catch (e) {
      print('Error getting user profile image URL: $e');
      return const Stream<String?>.empty();
    }
  }
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}