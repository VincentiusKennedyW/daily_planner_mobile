import 'package:flutter/material.dart';

class ViewToggleSwitch extends StatelessWidget {
  final bool isProjectView;
  final ValueChanged<bool> onChanged;

  const ViewToggleSwitch({
    super.key,
    required this.isProjectView,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Task',
            style: TextStyle(
              color: !isProjectView ? Color(0xFF6366F1) : Colors.grey[600],
              fontWeight: !isProjectView ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(width: 8),
          Switch(
            value: isProjectView,
            onChanged: onChanged,
            activeColor: Color(0xFF6366F1),
          ),
          SizedBox(width: 8),
          Text(
            'Project',
            style: TextStyle(
              color: isProjectView ? Color(0xFF6366F1) : Colors.grey[600],
              fontWeight: isProjectView ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
