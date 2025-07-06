import 'package:expense_tracker/app/data/models/project_models/project_model.dart';

class CreateProjectResponse {
  final String status;
  final String message;
  final ProjectModel data;

  CreateProjectResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateProjectResponse.fromJson(Map<String, dynamic> json) {
    return CreateProjectResponse(
      status: json['status'],
      message: json['message'],
      data: ProjectModel.fromJson(json['data']),
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
