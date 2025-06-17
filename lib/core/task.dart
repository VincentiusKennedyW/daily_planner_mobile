import 'package:flutter/material.dart';

enum TaskCategory {
  riset,
  boq,
  development,
  implementation,
  maintenance,
  assembly,
  systemDocumentation,
  optimationServer,
  deploymentServer,
  troubleshootServer,
}

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, completed, blocked }

extension TaskCategoryExtension on TaskCategory {
  String get name {
    switch (this) {
      case TaskCategory.riset:
        return 'Riset';
      case TaskCategory.boq:
        return 'BoQ';
      case TaskCategory.development:
        return 'Development';
      case TaskCategory.implementation:
        return 'Implementation';
      case TaskCategory.maintenance:
        return 'Maintenance';
      case TaskCategory.assembly:
        return 'Assembly';
      case TaskCategory.systemDocumentation:
        return 'System Documentation';
      case TaskCategory.optimationServer:
        return 'Optimation Server';
      case TaskCategory.deploymentServer:
        return 'Deployment Server';
      case TaskCategory.troubleshootServer:
        return 'Troubleshoot Server';
    }
  }

  int get points {
    switch (this) {
      case TaskCategory.riset:
        return 15;
      case TaskCategory.development:
        return 20;
      case TaskCategory.implementation:
        return 18;
      case TaskCategory.troubleshootServer:
        return 12;
      case TaskCategory.optimationServer:
        return 15;
      case TaskCategory.deploymentServer:
        return 10;
      case TaskCategory.boq:
        return 8;
      case TaskCategory.maintenance:
        return 10;
      case TaskCategory.assembly:
        return 12;
      case TaskCategory.systemDocumentation:
        return 8;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.riset:
        return Color(0xFF8B5CF6);
      case TaskCategory.development:
        return Color(0xFF10B981);
      case TaskCategory.implementation:
        return Color(0xFF3B82F6);
      case TaskCategory.troubleshootServer:
        return Color(0xFFEF4444);
      case TaskCategory.optimationServer:
        return Color(0xFFF59E0B);
      case TaskCategory.deploymentServer:
        return Color(0xFF06B6D4);
      case TaskCategory.boq:
        return Color(0xFF84CC16);
      case TaskCategory.maintenance:
        return Color(0xFF6366F1);
      case TaskCategory.assembly:
        return Color(0xFFEC4899);
      case TaskCategory.systemDocumentation:
        return Color(0xFF64748B);
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.riset:
        return Icons.science_rounded;
      case TaskCategory.development:
        return Icons.code_rounded;
      case TaskCategory.implementation:
        return Icons.build_rounded;
      case TaskCategory.troubleshootServer:
        return Icons.bug_report_rounded;
      case TaskCategory.optimationServer:
        return Icons.speed_rounded;
      case TaskCategory.deploymentServer:
        return Icons.cloud_upload_rounded;
      case TaskCategory.boq:
        return Icons.receipt_long_rounded;
      case TaskCategory.maintenance:
        return Icons.handyman_rounded;
      case TaskCategory.assembly:
        return Icons.precision_manufacturing_rounded;
      case TaskCategory.systemDocumentation:
        return Icons.description_rounded;
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Rendah';
      case TaskPriority.medium:
        return 'Sedang';
      case TaskPriority.high:
        return 'Tinggi';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.blocked:
        return 'Blocked';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.blocked:
        return Colors.red;
    }
  }
}

class Task {
  String id;
  String title;
  String description;
  TaskCategory category;
  TaskPriority priority;
  TaskStatus status;
  String assignee;
  DateTime createdAt;
  DateTime? dueDate;
  DateTime? completedAt;
  List<String> tags;
  int estimatedHours;
  List<TaskComment> comments;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    required this.assignee,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.estimatedHours = 1,
    List<TaskComment>? comments,
  }) : comments = comments ?? [];

  int get points => status == TaskStatus.completed ? category.points : 0;
  bool get isOverdue =>
      dueDate != null &&
      DateTime.now().isAfter(dueDate!) &&
      status != TaskStatus.completed;
}

class TaskComment {
  String id;
  String author;
  String content;
  DateTime createdAt;

  TaskComment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}
