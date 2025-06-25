import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  final CommentTaskController _commentTaskController = Get.find<CommentTaskController>();
  bool isAddingComment = false;

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => isAddingComment = true);

    final success = await _commentTaskController.addComment(
      _commentController.text.trim(),
    );

    setState(() => isAddingComment = false);

    if (success) {
      _commentController.clear();
    } else {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Ups, Ada Masalah!',
        message: _commentTaskController.errorMessage.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tulis komentar...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: isAddingComment ? null : _addComment,
                icon: isAddingComment
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.send_rounded, size: 16),
                label: Text(
                  isAddingComment ? 'Mengirim...' : 'Kirim',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}