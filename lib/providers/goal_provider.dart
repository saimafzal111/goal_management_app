import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/appwrite_database_service.dart';

class GoalProvider with ChangeNotifier {
  final List<Goal> _goals = [];
  final AppwriteDatabaseService _appwrite = AppwriteDatabaseService();

  List<Goal> get goals => List.unmodifiable(_goals);

  List<Goal> get completedGoals => _goals.where((g) => g.isCompleted).toList();
  List<Goal> get pendingGoals => _goals.where((g) => !g.isCompleted).toList();

  Future<Goal?> addGoal(Goal goal) async {
    // Try to persist to Appwrite first
    try {
      final created = await _appwrite.createGoal(goal);
      if (created != null) {
        _goals.add(created);
        notifyListeners();
        return created;
      }
    } catch (_) {}

    // Fallback to local-only add if Appwrite fails
    _goals.add(goal);
    notifyListeners();
    return goal;
  }

  Future<bool> updateGoal(Goal updatedGoal) async {
    final index = _goals.indexWhere((g) => g.id == updatedGoal.id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteGoal(String id) async {
    final before = _goals.length;
    _goals.removeWhere((g) => g.id == id);
    final after = _goals.length;
    final existed = after < before;
    notifyListeners();
    return existed;
  }

  Future<bool> addMilestone(String goalId, Milestone milestone) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      _goals[goalIndex].milestones.add(milestone);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> toggleMilestone(String goalId, String milestoneId) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final milestoneIndex =
          _goals[goalIndex].milestones.indexWhere((m) => m.id == milestoneId);
      if (milestoneIndex != -1) {
        _goals[goalIndex].milestones[milestoneIndex].isCompleted =
            !_goals[goalIndex].milestones[milestoneIndex].isCompleted;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> deleteMilestone(String goalId, String milestoneId) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final before = _goals[goalIndex].milestones.length;
      _goals[goalIndex].milestones.removeWhere((m) => m.id == milestoneId);
      final after = _goals[goalIndex].milestones.length;
      final removed = after < before;
      notifyListeners();
      return removed;
    }
    return false;
  }
}
