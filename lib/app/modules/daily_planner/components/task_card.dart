import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/helper/format_date_helper.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';

Widget buildTaskCard(TaskListModel task) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: task.category.color.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: task.status == TaskStatus.overdue
            ? Colors.red.withOpacity(0.3)
            : task.category.color.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: InkWell(
      // onTap: () => _showTaskDetail(task),
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: task.category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    task.category.icon,
                    color: task.category.color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        task.category.name,
                        style: TextStyle(
                          color: task.category.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // PopupMenuButton<String>(
                //   onSelected: (value) => _handleTaskAction(task, value),
                //   itemBuilder: (context) => [
                //     PopupMenuItem(value: 'edit', child: Text('Edit')),
                //     PopupMenuItem(value: 'comment', child: Text('Komentar')),
                //     PopupMenuItem(value: 'assign', child: Text('Assign')),
                //     PopupMenuItem(value: 'delete', child: Text('Hapus')),
                //   ],
                // ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                task.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.priority.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.priority.name,
                    style: TextStyle(
                      color: task.priority.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.status.name,
                    style: TextStyle(
                      color: task.status.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                if (task.status == TaskStatus.overdue)
                  Icon(Icons.warning_rounded, color: Colors.red, size: 16),
                if (task.dueDate != null) ...[
                  Icon(Icons.schedule_rounded,
                      color: Colors.grey[500], size: 14),
                  SizedBox(width: 4),
                  Text(
                    formatDate(task.dueDate!),
                    style: TextStyle(
                      color: task.status == TaskStatus.overdue
                          ? Colors.red
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: task.assignees!.map((assignee) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  Color(0xFF6366F1).withOpacity(0.1),
                              child: Text(
                                assignee.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              assignee.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${task.category.points} poin',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (task.status == TaskStatus.todo) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_arrow_rounded, size: 16),
                      label: Text('Mulai', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        foregroundColor: Colors.blue,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (task.status == TaskStatus.inProgress) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.check_rounded, size: 16),
                      label: Text('Selesai', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        foregroundColor: Colors.green,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
