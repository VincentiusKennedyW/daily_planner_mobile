import 'package:expense_tracker/core/task_model.dart';

class TaskAssigneeModel {
  final String status;
  final String message;
  final TaskAssigneeData data;

  TaskAssigneeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TaskAssigneeModel.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeModel(
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
  final User user;
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

  factory TaskAssigneeData.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeData(
      user: User.fromJson(json['user']),
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

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class Period {
  final int year;
  final int month;
  final String startDate;
  final String endDate;

  Period({
    required this.year,
    required this.month,
    required this.startDate,
    required this.endDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      year: json['year'],
      month: json['month'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
