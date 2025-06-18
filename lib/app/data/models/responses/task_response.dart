import 'package:expense_tracker/app/data/models/task_models/task_model.dart';

class GetAllTasksResponse {
  final String status;
  final String message;
  final GetAllTasksData data;

  GetAllTasksResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllTasksResponse.fromJson(Map<String, dynamic> json) {
    return GetAllTasksResponse(
      status: json['status'],
      message: json['message'],
      data: GetAllTasksData.fromJson(json['data']),
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
