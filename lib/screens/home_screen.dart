import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/goal_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

import 'goals_list_screen.dart';
import 'add_goal_screen.dart';
import 'goal_details_screen.dart';
import 'profile_screen.dart';

import '../widgets/goal_card.dart';
import '../widgets/statistics_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    // Calculate statistics
    final totalGoals = goalProvider.goals.length;
    final completedGoals =
        goalProvider.goals.where((g) => g.isCompleted).length;
    final inProgressGoals = totalGoals - completedGoals;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.name ?? 'User'} 👋',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Let\'s crush your goals today',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Builder(builder: (ctx) {
                      final userProvider = ctx.watch<UserProvider>();
                      final auth = context.read<AuthProvider>().user;

                      ImageProvider? avatarImage;
                      if (userProvider.userImageBase64.isNotEmpty) {
                        try {
                          avatarImage = MemoryImage(base64Decode(userProvider.userImageBase64));
                        } catch (_) {
                          avatarImage = null;
                        }
                      } else if (userProvider.userImagePath.isNotEmpty && !kIsWeb) {
                        avatarImage = FileImage(File(userProvider.userImagePath));
                      } else {
                        avatarImage = null; // will show initials
                      }

                      final nameSource = auth?.name ?? userProvider.userName;
                      final initials = nameSource
                          .split(' ')
                          .where((s) => s.isNotEmpty)
                          .map((s) => s[0])
                          .take(2)
                          .join()
                          .toUpperCase();

                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: avatarImage,
                        child: avatarImage == null
                            ? Text(
                                initials.isNotEmpty ? initials : 'U',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            : null,
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Statistics
              StatisticsCard(
                totalGoals: totalGoals,
                completedGoals: completedGoals,
                inProgressGoals: inProgressGoals,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Motivation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      // ignore: deprecated_member_use
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          // ignore: deprecated_member_use
                          .withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Motivation',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '"The only way to do great work is to love what you do."',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '- Steve Jobs',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 500.ms),

              const SizedBox(height: 32),

              // Recent Goals Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Goals',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalsListScreen(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Goals list
              if (goalProvider.goals.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.assignment_add,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No goals yet. Start by adding one!',
                          style:
                              TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: goalProvider.goals.length > 3
                      ? 3
                      : goalProvider.goals.length,
                  itemBuilder: (context, index) {
                    final goal = goalProvider.goals[index];
                    return GoalCard(
                      goal: goal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GoalDetailsScreen(goalId: goal.id),
                          ),
                        );
                      },
                      onDelete: () async {
                        final success =
                            await goalProvider.deleteGoal(goal.id);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Goal deleted')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Failed to delete goal')),
                          );
                        }
                      },
                    )
                        .animate()
                        .fadeIn(delay: (index * 100).ms)
                        .slideX();
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddGoalScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
