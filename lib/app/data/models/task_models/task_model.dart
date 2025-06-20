import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/task_models/comment_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_helper.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/core/task.dart';

class TaskListModel {
  final int id;
  final String title;
  final String description;
  final TaskCategory category;
  final int point;
  final TaskPriority priority;
  late final TaskStatus status;
  final List<UserWithName>? assignees;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final List<String>? tags;
  final int? estimatedHours;
  final UserWithName creator;
  final List<Comment>? comments;

  TaskListModel({
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
    this.comments,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: TaskModelHelper.parseTaskCategory(json['category']),
      point: json['point'],
      priority: TaskModelHelper.parseTaskPriority(json['priority']),
      status: TaskModelHelper.parseTaskStatus(json['status']),
      assignees: json['assignees'] != null
          ? (json['assignees'] as List)
              .map((assignee) => UserWithName.fromJson(assignee))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      estimatedHours: json['estimatedHours'],
      creator: UserWithName.fromJson(json['creator']),
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((comment) => Comment.fromJson(comment))
              .toList()
          : null,
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
      'comments': comments?.map((comment) => comment.toJson()).toList(),
    };
  }
}

class GetAllTasksData {
  final List<TaskListModel> tasks;
  final Pagination pagination;

  GetAllTasksData({
    required this.tasks,
    required this.pagination,
  });

  factory GetAllTasksData.fromJson(Map<String, dynamic> json) {
    return GetAllTasksData(
      tasks: (json['tasks'] as List)
          .map((task) => TaskListModel.fromJson(task))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
