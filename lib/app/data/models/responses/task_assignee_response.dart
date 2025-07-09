import 'package:expense_tracker/app/data/models/task_models/period_model.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/core/task_model.dart';

class TaskAssigneeResponse {
  final String status;
  final String message;
  final TaskAssigneeData data;

  TaskAssigneeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  TaskAssigneeResponse copyWith({
    String? status,
    String? message,
    TaskAssigneeData? data,
  }) {
    return TaskAssigneeResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TaskAssigneeResponse.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeResponse(
      status: json['status'],
      message: json['message'],
      data: TaskAssigneeData.fromJson(json['data']),
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

class TaskAssigneeData {
  final UserWithEmail user;
  final int total;
  final int completed;
  final int inProgress;
  final int todo;
  final int overdue;
  final int totalPoints;
  final Period? period;
  final TaskCategory byCategory;
  final TaskPriority byPriority;

  TaskAssigneeData({
    required this.user,
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.todo,
    required this.overdue,
    required this.totalPoints,
    this.period,
    required this.byCategory,
    required this.byPriority,
  });

  TaskAssigneeData copyWith({
    UserWithEmail? user,
    int? total,
    int? completed,
    int? inProgress,
    int? todo,
    int? overdue,
    int? totalPoints,
    Period? period,
    TaskCategory? byCategory,
    TaskPriority? byPriority,
  }) {
    return TaskAssigneeData(
      user: user ?? this.user,
      total: total ?? this.total,
      completed: completed ?? this.completed,
      inProgress: inProgress ?? this.inProgress,
      todo: todo ?? this.todo,
      overdue: overdue ?? this.overdue,
      totalPoints: totalPoints ?? this.totalPoints,
      period: period ?? this.period,
      byCategory: byCategory ?? this.byCategory,
      byPriority: byPriority ?? this.byPriority,
    );
  }

  factory TaskAssigneeData.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeData(
      user: UserWithEmail.fromJson(json['user']),
      total: json['total'],
      completed: json['completed'],
      inProgress: json['inProgress'],
      todo: json['todo'],
      overdue: json['overdue'],
      totalPoints: json['totalPoints'],
      period: json['period'] != null ? Period.fromJson(json['period']) : null,
      byCategory: TaskCategory.fromJson(json['byCategory']),
      byPriority: TaskPriority.fromJson(json['byPriority']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'total': total,
      'completed': completed,
      'inProgress': inProgress,
      'todo': todo,
      'overdue': overdue,
      'totalPoints': totalPoints,
      'period': period?.toJson(),
      'byCategory': byCategory.toJson(),
      'byPriority': byPriority.toJson(),
    };
  }
}
