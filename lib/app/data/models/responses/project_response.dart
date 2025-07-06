import 'package:expense_tracker/app/data/models/project_models/project_model.dart';

class GetAllProjectResponse {
  final String status;
  final String message;
  final GetAllProjectData? data;

  GetAllProjectResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetAllProjectResponse.fromJson(Map<String, dynamic> json) {
    return GetAllProjectResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? GetAllProjectData.fromJson(json['data'])
          : null,
    );
  }
}
