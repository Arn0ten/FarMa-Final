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
      throw e;
    }
  }

  Future<void> updateUserAddress(String userId, String newAddress) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .update({'address': newAddress});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserEmail(String userId, int newEmail) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .update({'email': newEmail});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserFullName(String userId, int newNewUserFullname) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .update({'fullName': newNewUserFullname});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserContactNumber(
      String userId, int newContactNumber) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .update({'contactNumber': newContactNumber});
    } catch (e) {
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
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (searchTerm.isEmpty) {
        return [];
      } else {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
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
      return [];
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (uid.isNotEmpty) {
        String imageId = DateTime.now().millisecondsSinceEpoch.toString();
        String imagePath = 'user_profile_images/$uid/$imageId.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);

        UploadTask uploadTask = storageReference.putFile(imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        if (taskSnapshot.state == TaskState.success) {
          String downloadUrl = await storageReference.getDownloadURL();

          await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);

          await _firestore
              .collection('Farma Users')
              .doc(uid)
              .set({'photoURL': downloadUrl}, SetOptions(merge: true));

          return downloadUrl;
        } else {
          throw ('Image upload failed');
        }
      } else {
        throw ('User is not authenticated');
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  Future<String?> getUserProfileImageURL() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      if (uid.isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          if (currentUser.photoURL != null &&
              currentUser.photoURL!.isNotEmpty) {
            return currentUser.photoURL;
          } else {
            DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                await _firestore.collection('Farma Users').doc(uid).get();
            if (userSnapshot.exists) {
              Map<String, dynamic> userData = userSnapshot.data() ?? {};
              String? photoURL = userData['photoURL'];
              return photoURL;
            } else {
              return null;
            }
          }
        }
      }
      return null;
    } catch (e) {
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
        if (snapshot.exists) {
          Map<String, dynamic> userData = snapshot.data() ?? {};
          return userData['photoURL'];
        } else {
          return null;
        }
      });
    } catch (e) {
      return const Stream<String?>.empty();
    }
  }

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
