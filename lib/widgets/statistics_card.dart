import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final int totalGoals;
  final int completedGoals;
  final int inProgressGoals;

  const StatisticsCard({
    super.key,
    required this.totalGoals,
    required this.completedGoals,
    required this.inProgressGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE0E7FF),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.flag_rounded,
            label: 'Total',
            value: totalGoals.toString(),
            color: const Color(0xFF6366F1),
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            icon: Icons.check_circle_rounded,
            label: 'Completed',
            value: completedGoals.toString(),
            color: Colors.green,
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            icon: Icons.pending_actions_rounded,
            label: 'In Progress',
            value: inProgressGoals.toString(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
