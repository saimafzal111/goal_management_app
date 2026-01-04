import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userName = 'Saim';
  String _userEmail = '';
  // If on web we store image as base64; on mobile/desktop we can store file path
  String _userImagePath = '';
  String _userImageBase64 = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userImagePath => _userImagePath;
  String get userImageBase64 => _userImageBase64;

  void setUser({required String name, required String email, String? imagePath, String? imageBase64}) {
    _userName = name;
    _userEmail = email;
    if (imagePath != null) _userImagePath = imagePath;
    if (imageBase64 != null) _userImageBase64 = imageBase64;
    notifyListeners();
  }

  void setImagePath(String path) {
    _userImagePath = path;
    notifyListeners();
  }

  void setImageBase64(String base64) {
    _userImageBase64 = base64;
    notifyListeners();
  }

  void clearImage() {
    _userImagePath = '';
    _userImageBase64 = '';
    notifyListeners();
  }

  void logout() {
    _userName = 'Saim';
    _userEmail = '';
    clearImage();
    notifyListeners();
  }
}
