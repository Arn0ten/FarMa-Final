import 'package:flutter/material.dart';

class ProfileImageProvider with ChangeNotifier {
  late String _profileImageUrl;

  ProfileImageProvider() {
    // Initialize with an empty string, you can also load the URL from local storage if available.
    _profileImageUrl = '';
  }

  String get profileImageUrl => _profileImageUrl;

  void updateProfileImage(String newImageUrl) {
    _profileImageUrl = newImageUrl;
    notifyListeners();
  }
}
