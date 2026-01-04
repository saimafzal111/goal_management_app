import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart';

class AppwriteAuthServices {
  final Account _account = AppwriteClient.account;

  /// Get currently logged-in user
  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    }
  }

  /// Login with email & password
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return await getCurrentUser();
    } on AppwriteException catch (e) {
      // If a session already exists (race/cookie), try deleting the current session and retry once
      final msg = (e.message ?? '').toLowerCase();
      if (msg.contains('session') || msg.contains('already') || msg.contains('exists')) {
        try {
          await _account.deleteSession(sessionId: 'current');
        } catch (_) {}
        try {
          await _account.createEmailPasswordSession(email: email, password: password);
          return await getCurrentUser();
        } on AppwriteException catch (_) {
          throw e.message ?? 'Login failed';
        }
      }
      throw e.message ?? 'Login failed';
    }
  }

  /// Register user & auto login
  Future<User?> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return await login(email: email, password: password);
    } on AppwriteException catch (e) {
      throw e.message ?? 'Registration failed';
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException {
      // ignore logout errors — ensure client-side state is cleared by provider
    }
  }
}
