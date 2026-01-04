import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/goal_provider.dart';
import '../models/goal.dart';
import 'add_goal_screen.dart';
import '../widgets/milestone_item.dart';

class GoalDetailsScreen extends StatelessWidget {
  final String goalId;

  const GoalDetailsScreen({super.key, required this.goalId});

  // Define primary color constant
  static const Color primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalProvider>(
      builder: (context, goalProvider, child) {
        // Better null safety handling
        final goal = goalProvider.goals.cast<Goal?>().firstWhere(
          (g) => g?.id == goalId,
          orElse: () => null,
        );

        if (goal == null) {
          return const Scaffold(
            body: Center(child: Text('Goal not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(goal.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit screen (reuse AddGoalScreen with arguments)
                  () async {
                    final result = await Navigator.push<bool?>(
                      context,
                      MaterialPageRoute(builder: (_) => AddGoalScreen(goal: goal)),
                    );
                    if (result == true) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Goal updated')),
                      );
                    }
                  }();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmation(context, goalProvider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    goal.category,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  goal.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Due ${DateFormat('MMMM d, y').format(goal.deadline)}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                Text(
                  goal.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                // Progress Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // ignore: deprecated_member_use
                        primaryColor.withOpacity(0.1),
                        const Color(0xFFE0E7FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Large Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: goal.progress,
                              strokeWidth: 8,
                              // ignore: deprecated_member_use
                              backgroundColor: Colors.white.withOpacity(0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                goal.isCompleted ? Colors.green : primaryColor,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(goal.progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                'Complete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Statistics
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatRow(
                              context,
                              icon: Icons.assignment_turned_in_rounded,
                              label: 'Total Tasks',
                              value: goal.milestones.length.toString(),
                            ),
                            const SizedBox(height: 12),
                            _buildStatRow(
                              context,
                              icon: Icons.check_circle_rounded,
                              label: 'Completed',
                              value: goal.milestones.where((m) => m.isCompleted).length.toString(),
                              color: Colors.green,
                            ),
                            const SizedBox(height: 12),
                            _buildStatRow(
                              context,
                              icon: Icons.pending_actions_rounded,
                              label: 'Remaining',
                              value: goal.milestones.where((m) => !m.isCompleted).length.toString(),
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Milestones',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        _showAddMilestoneDialog(context, goalProvider, goalId);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (goal.milestones.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No milestones yet. Add one to track progress!',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: goal.milestones.length,
                    itemBuilder: (context, index) {
                      final milestone = goal.milestones[index];
                      return MilestoneItem(
                        milestone: milestone,
                        onToggle: () async {
                          final success = await goalProvider.toggleMilestone(goalId, milestone.id);
                          if (!context.mounted) return;
                          
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to update milestone')),
                            );
                          }
                        },
                        onDelete: () async {
                          final success = await goalProvider.deleteMilestone(goalId, milestone.id);
                          if (!context.mounted) return;
                          
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Milestone deleted')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to delete milestone')),
                            );
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    GoalProvider goalProvider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: const Text(
          'This will permanently delete this goal and all its milestones. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await goalProvider.deleteGoal(goalId);
      if (!context.mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal deleted')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete goal')),
        );
      }
    }
  }

  void _showAddMilestoneDialog(
    BuildContext context,
    GoalProvider provider,
    String goalId,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Milestone'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Milestone title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                return;
              }
              
              final success = await provider.addMilestone(
                goalId,
                Milestone(title: controller.text.trim()),
              );
              
              if (!context.mounted) return;
              Navigator.pop(context);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Milestone added')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to add milestone')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}