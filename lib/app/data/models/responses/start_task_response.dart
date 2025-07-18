class TaskProgressResponse {
  final String message;
  final String status;
  final StartTaskData data;

  TaskProgressResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory TaskProgressResponse.fromJson(Map<String, dynamic> json) {
    return TaskProgressResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 'error',
      data: StartTaskData.fromJson(json['data'] ?? {}),
    );
  }
}

class StartTaskData {
  final int id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int pointsEarned;
  final List<AssignedAssigneeData>? assignee;
  final SimpleTaskData task;

  StartTaskData({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.pointsEarned,
    required this.assignee,
    required this.task,
  });

  factory StartTaskData.fromJson(Map<String, dynamic> json) {
    return StartTaskData(
      id: json['id'] ?? 0,
      startedAt:
          DateTime.parse(json['startedAt'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      pointsEarned: json['pointsEarned'] ?? 0,
      assignee: (json['assignee'] as List?)
          ?.map((item) => AssignedAssigneeData.fromJson(item))
          .toList(),
      task: SimpleTaskData.fromJson(json['task'] ?? {}),
    );
  }
}

class AssignedAssigneeData {
  final int id;
  final String name;

  AssignedAssigneeData({
    required this.id,
    required this.name,
  });

  factory AssignedAssigneeData.fromJson(Map<String, dynamic> json) {
    return AssignedAssigneeData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class SimpleTaskData {
  final int id;
  final String title;

  SimpleTaskData({
    required this.id,
    required this.title,
  });

  factory SimpleTaskData.fromJson(Map<String, dynamic> json) {
    return SimpleTaskData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}
