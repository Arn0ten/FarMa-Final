import 'package:flutter/foundation.dart';

class ProfileImageProvider with ChangeNotifier {
  String _imagePath = '';

  String get imagePath => _imagePath;

  void setImagePath(String newPath) {
    _imagePath = newPath;
    notifyListeners();
  }
}
