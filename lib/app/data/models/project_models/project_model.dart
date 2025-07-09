import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';

class ProjectModel {
  final int id;
  final String name;
  final String projectNo;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaskListModel>? tasks;

  ProjectModel({
    required this.id,
    required this.name,
    required this.projectNo,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.tasks,
  });

  ProjectModel copyWith({
    int? id,
    String? name,
    String? projectNo,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TaskListModel>? tasks,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      projectNo: projectNo ?? this.projectNo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tasks: tasks ?? this.tasks,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      projectNo: json['projectNo'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tasks: json['tasks'] != null && (json['tasks'] as List).isNotEmpty
          ? (json['tasks'] as List)
              .map((task) => TaskListModel.fromJson(task as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectNo': projectNo,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tasks': tasks?.map((task) => task.toJson()).toList(),
    };
  }
}

class GetAllProjectData {
  final List<ProjectModel> projects;
  final Pagination pagination;

  GetAllProjectData({
    required this.projects,
    required this.pagination,
  });

  factory GetAllProjectData.fromJson(Map<String, dynamic> json) {
    return GetAllProjectData(
      projects: (json['projects'] as List)
          .map((project) => ProjectModel.fromJson(project))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
