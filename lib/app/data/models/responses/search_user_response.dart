import 'package:expense_tracker/app/data/models/leaderboard_model.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';

class SearchUserResponse {
  final String status;
  final String message;
  final SearchUserData? data;

  SearchUserResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) {
    return SearchUserResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? SearchUserData.fromJson(json['data']) : null,
    );
  }
}

class SearchUserData {
  final List<UserModel> users;
  final Pagination pagination;

  SearchUserData({
    required this.users,
    required this.pagination,
  });

  factory SearchUserData.fromJson(Map<String, dynamic> json) {
    return SearchUserData(
      users: (json['users'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
