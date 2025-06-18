import 'package:expense_tracker/app/data/models/task_models/task_helper.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/core/task.dart';

class CreateTaskResponse {
  final String status;
  final String message;
  final CreatedTaskModel data;

  CreateTaskResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) {
    return CreateTaskResponse(
      status: json['status'],
      message: json['message'],
      data: CreatedTaskModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CreatedTaskModel {
  final int id;
  final String title;
  final String description;
  final TaskCategory category;
  final int point;
  final TaskPriority priority;
  final TaskStatus status;
  final List<UserResponse>? assignees;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final List<String>? tags;
  final int? estimatedHours;
  final UserResponse creator;

  CreatedTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.point,
    required this.priority,
    required this.status,
    this.assignees,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.tags,
    this.estimatedHours,
    required this.creator,
  });

  factory CreatedTaskModel.fromJson(Map<String, dynamic> json) {
    return CreatedTaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: TaskModelHelper.parseTaskCategory(json['category']),
      point: json['point'],
      priority: TaskModelHelper.parseTaskPriority(json['priority']),
      status: TaskModelHelper.parseTaskStatus(json['status']),
      assignees: json['assignees'] != null
          ? (json['assignees'] as List)
              .map((assignee) => UserResponse.fromJson(assignee))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      estimatedHours: json['estimatedHours'],
      creator: UserResponse.fromJson(json['creator']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': TaskModelHelper.taskCategoryToString(category),
      'point': point,
      'priority': TaskModelHelper.taskPriorityToString(priority),
      'status': TaskModelHelper.taskStatusToString(status),
      'assignees': assignees?.map((assignee) => assignee.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'tags': tags,
      'estimatedHours': estimatedHours,
      'creator': creator.toJson(),
    };
  }
}

