import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/appwrite_auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AppwriteAuthServices _authServices = AppwriteAuthServices();

  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Check existing session (call from splash screen)
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      _user = await _authServices.getCurrentUser();
    } catch (e) {
      _user = null;
    }
    _setLoading(false);
  }

  /// Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    clearError();
    try {
      _user = await _authServices.login(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Register
  Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    _setLoading(true);
    clearError();
    try {
      _user = await _authServices.register(
        email: email,
        password: password,
        name: name,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authServices.logout();
      _user = null;
    } catch (_) {}
    _setLoading(false);
  }
}
