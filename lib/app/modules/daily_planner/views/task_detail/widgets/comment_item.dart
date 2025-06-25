import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/data/models/task_models/comment_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/core/helper/format_date_helper.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isMyComment;
  final CommentTaskController _commentTaskController =
      Get.find<CommentTaskController>();

  CommentItem({
    super.key,
    required this.comment,
    required this.isMyComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isMyComment ? Color(0xFF6366F1).withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMyComment
              ? Color(0xFF6366F1).withOpacity(0.2)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 8),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isMyComment ? Color(0xFF6366F1) : Colors.grey[400],
          child: Text(
            comment.user.name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.user.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                formatDateWithTime(comment.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        if (isMyComment) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Saya',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          _buildDeleteButton(context),
        ],
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      comment.content,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        height: 1.4,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hapus Komentar'),
            content: Text('Apakah Anda yakin ingin menghapus komentar ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: Text('Hapus'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final success =
              await _commentTaskController.deleteComment(comment.id);
          if (!success) {
            showCustomSnackbar(
              isSuccess: false,
              title: 'Ups, Ada Masalah!',
              message: _commentTaskController.errorMessage.value,
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 16,
          color: Colors.red,
        ),
      ),
    );
  }
}
