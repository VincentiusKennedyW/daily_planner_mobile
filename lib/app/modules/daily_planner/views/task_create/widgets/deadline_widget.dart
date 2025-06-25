import 'package:flutter/material.dart';

class DeadlineSection extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onSelectDate;

  const DeadlineSection({
    super.key,
    required this.dueDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deadline',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onSelectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 20),
                const SizedBox(width: 12),
                Text(dueDate != null
                    ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                    : 'Pilih tanggal'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
