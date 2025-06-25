import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/comment_item.dart';

class CommentList extends StatelessWidget {
  final CommentTaskController _commentTaskController =
      Get.find<CommentTaskController>();
  final GetStorage _storage = GetStorage();

  CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_commentTaskController.isLoadingComment.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        );
      }

      if (_commentTaskController.currentTask.value?.comments?.isEmpty ?? true) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 48,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada komentar',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount:
            _commentTaskController.currentTask.value?.comments?.length ?? 0,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comment =
              _commentTaskController.currentTask.value!.comments![index];

          String? userDataResponse = _storage.read('user_data');
          String userId = '0';

          if (userDataResponse != null) {
            final Map<String, dynamic> userData = jsonDecode(userDataResponse);
            userId = userData['id']?.toString() ?? '0';
          }

          final isMyComment = comment.user.id == int.tryParse(userId);

          return CommentItem(
            comment: comment,
            isMyComment: isMyComment,
          );
        },
      );
    });
  }
}
