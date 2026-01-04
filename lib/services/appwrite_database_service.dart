import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/goal.dart';
import 'appwrite_client.dart';

class AppwriteDatabaseService {
  final Databases _databases = Databases(AppwriteClient.client);

  final String _databaseId =
      dotenv.env['APPWRITE_DATABASE_ID'] ?? '';
  final String _goalsCollectionId =
      dotenv.env['APPWRITE_GOALS_COLLECTION_ID'] ?? '';

  /// =========================
  /// CREATE GOAL
  /// =========================
  Future<Goal?> createGoal(Goal goal) async {
    try {
      final user = await AppwriteClient.account.get();

      final document = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _goalsCollectionId,
        documentId: ID.unique(),
        data: goal.toMap(user.$id),
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );

      return Goal.fromMap(document.$id, document.data);
    } on AppwriteException catch (e) {
      print('Create Goal Error: ${e.message}');
      return null;
    }
  }

  /// =========================
  /// READ USER GOALS
  /// =========================
  Future<List<Goal>> getUserGoals() async {
    try {
      final user = await AppwriteClient.account.get();

      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _goalsCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('\$createdAt'),
        ],
      );

      return result.documents
          .map((doc) => Goal.fromMap(doc.$id, doc.data))
          .toList();
    } on AppwriteException catch (e) {
      print('Fetch Goals Error: ${e.message}');
      return [];
    }
  }

  /// =========================
  /// UPDATE GOAL
  /// =========================
  Future<bool> updateGoal(Goal goal) async {
    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _goalsCollectionId,
        documentId: goal.id,
        data: {
          'title': goal.title,
          'description': goal.description,
          'category': goal.category,
          'deadline': goal.deadline.toIso8601String(),
          'isCompleted': goal.isCompleted,
          'milestones': goal.milestones.map((m) => m.toMap()).toList(),
        },
      );
      return true;
    } on AppwriteException catch (e) {
      print('Update Goal Error: ${e.message}');
      return false;
    }
  }

  /// =========================
  /// DELETE GOAL
  /// =========================
  Future<bool> deleteGoal(String goalId) async {
    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _goalsCollectionId,
        documentId: goalId,
      );
      return true;
    } on AppwriteException catch (e) {
      print('Delete Goal Error: ${e.message}');
      return false;
    }
  }
}
