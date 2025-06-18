import 'package:expense_tracker/app/data/models/task_models/task_helper.dart';
import 'package:expense_tracker/core/task.dart';

class CreateTaskModel {
  final String title;
  final String description;
  final TaskCategory category;
  final int point;
  final TaskPriority priority;
  final TaskStatus status;
  final List<int>? assignees;
  final DateTime? dueDate;
  final List<String>? tags;
  final int? estimatedHours;

  CreateTaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.point,
    required this.priority,
    this.status = TaskStatus.todo,
    this.assignees,
    this.dueDate,
    this.tags,
    this.estimatedHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': TaskModelHelper.taskCategoryToString(category),
      'point': point,
      'priority': TaskModelHelper.taskPriorityToString(priority),
      'status': TaskModelHelper.taskStatusToString(status),
      'assignees': assignees,
      // Pastikan dueDate di-convert ke UTC dan berakhiran 'Z'
      'dueDate': dueDate?.toUtc().toIso8601String(),
      'tags': tags,
      'estimatedHours': estimatedHours,
    };
  }
}
