import 'package:flutter/material.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/helper/format_date_helper.dart';
import 'package:expense_tracker/core/task.dart';

class TaskInfoCard extends StatelessWidget {
  final TaskListModel? task;

  const TaskInfoCard({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    if (task == null) return SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: task?.status == TaskStatus.overdue
                ? Colors.red.withOpacity(0.1)
                : (task?.category.color ?? Colors.grey).withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: task?.status == TaskStatus.overdue
              ? Colors.red.withOpacity(0.3)
              : (task?.category.color ?? Colors.grey).withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(),
          SizedBox(height: 8),
          _buildCreatorInfo(),
          SizedBox(height: 8),
          _buildTitle(),
          if (task!.description.isNotEmpty) ...[
            SizedBox(height: 12),
            _buildDescription(),
          ],
          SizedBox(height: 20),
          _buildStatusRow(),
          if (task?.dueDate != null) ...[
            SizedBox(height: 16),
            _buildDueDate(),
          ],
          if (task?.assignees != null && task!.assignees!.isNotEmpty) ...[
            SizedBox(height: 20),
            _buildAssignees(),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: task?.category.color.withOpacity(0.1) ?? Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            task?.category.icon ?? Icons.category_rounded,
            color: task?.category.color ?? Colors.grey[800],
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task?.category.name ?? 'Tanpa Kategori',
                style: TextStyle(
                  color: task?.category.color ?? Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${task?.point ?? 0} poin',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorInfo() {
    return Row(
      children: [
        Text(
          'Dibuat oleh ${task?.creator.name}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Spacer(),
        Text(
          formatDateWithTime(task!.createdAt),
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      task?.title ?? 'Tanpa Judul',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.grey[800],
        decoration: task?.status == TaskStatus.completed
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      task!.description,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: task?.priority.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task!.priority.name,
            style: TextStyle(
              color: task?.priority.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: task?.status.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task!.status.name,
            style: TextStyle(
              color: task?.status.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacer(),
        if (task?.status == TaskStatus.overdue)
          Icon(Icons.warning_rounded, color: Colors.red, size: 20),
      ],
    );
  }

  Widget _buildDueDate() {
    return Row(
      children: [
        Icon(Icons.schedule_rounded, color: Colors.grey[500], size: 16),
        SizedBox(width: 8),
        Text(
          'Deadline: ${formatDate(task!.dueDate!)}',
          style: TextStyle(
            color: task?.status == TaskStatus.overdue
                ? Colors.red
                : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAssignees() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignees',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: task!.assignees!.map((assignee) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF6366F1),
                    child: Text(
                      assignee.name?[0].toUpperCase() ?? '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    assignee.name ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
