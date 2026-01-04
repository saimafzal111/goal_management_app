import 'package:flutter/material.dart';
import '../models/goal.dart';

class MilestoneItem extends StatelessWidget {
  final Milestone milestone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const MilestoneItem({
    super.key,
    required this.milestone,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: milestone.isCompleted 
            // ignore: deprecated_member_use
            ? Colors.green.withOpacity(0.05) 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: milestone.isCompleted 
              // ignore: deprecated_member_use
              ? Colors.green.withOpacity(0.3) 
              // ignore: deprecated_member_use
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Custom Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: milestone.isCompleted 
                        ? Colors.green 
                        : Colors.transparent,
                    border: Border.all(
                      color: milestone.isCompleted 
                          ? Colors.green 
                          : const Color(0xFF6366F1),
                      width: 2,
                    ),
                  ),
                  child: milestone.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Task Title
                Expanded(
                  child: Text(
                    milestone.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: milestone.isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                      color: milestone.isCompleted 
                          ? Colors.grey.shade500 
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                // Delete Button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
