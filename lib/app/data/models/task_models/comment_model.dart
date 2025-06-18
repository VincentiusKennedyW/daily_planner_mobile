import 'package:expense_tracker/app/data/models/user_model.dart';

class Comment {
  final int id;
  final UserResponse user;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: UserResponse.fromJson(json['user']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
