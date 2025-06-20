import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';

class PrioritySection extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final ValueChanged<TaskPriority>? onSelectPriority;

  const PrioritySection({
    super.key,
    this.selectedPriority,
    this.onSelectPriority,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioritas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskPriority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            return GestureDetector(
              onTap: () => onSelectPriority?.call(priority),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? priority.color.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? priority.color : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: priority.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      priority.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? priority.color : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
