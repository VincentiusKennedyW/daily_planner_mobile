import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/comment_input.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/comment_list.dart';

class CommentSection extends StatelessWidget {
  final CommentTaskController _commentTaskController =
      Get.find<CommentTaskController>();

  CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildHeader()),
          SizedBox(height: 16),
          CommentInput(),
          SizedBox(height: 20),
          CommentList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.comment_rounded, color: Color(0xFF6366F1), size: 20),
        SizedBox(width: 8),
        Text(
          'Komentar (${_commentTaskController.currentTask.value?.comments?.length ?? 0})',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
