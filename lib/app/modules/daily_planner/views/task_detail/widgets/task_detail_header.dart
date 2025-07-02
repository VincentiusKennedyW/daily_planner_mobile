import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/delete_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/update_task_sheet.dart';
import 'package:expense_tracker/global_widgets/custom_confirmation_dialog.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailHeader extends StatelessWidget implements PreferredSizeWidget {
  final TaskListModel task;

  const TaskDetailHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final commentController = Get.find<CommentTaskController>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.grey[800]),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Detail Task',
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Obx(() {
          final currentTask = commentController.currentTask.value ?? task;
          return PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey[800]),
            onSelected: (String value) {
              switch (value) {
                case 'update':
                  _showUpdateTaskSheet(context, currentTask);
                  break;
                case 'delete':
                  _showDeleteConfirmation(context, currentTask);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'update',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text('Update Task'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Task'),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

void _showUpdateTaskSheet(BuildContext context, TaskListModel task) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => UpdateTaskSheet(
      task: task,
    ),
  );
}

void _showDeleteConfirmation(BuildContext context, TaskListModel task) async {
  await ConfirmationDialogHelper.showDelete(
    title: 'Hapus Task',
    message: 'Apakah Anda yakin ingin menghapus task "${task.title}"?',
    confirmText: 'Ya, Hapus',
    cancelText: 'Batal',
    onConfirm: () async {
      final deleteTaskController = Get.find<DeleteTaskController>();
      final success = await deleteTaskController.deleteTask(task.id);

      if (success) {
        Get.back();
        showCustomSnackbar(
          isSuccess: true,
          title: 'Berhasil',
          message: 'Task "${task.title}" berhasil dihapus',
        );
      } else {
        showCustomSnackbar(
          isSuccess: false,
          title: 'Gagal',
          message: deleteTaskController.errorMessageDelete.value,
        );
      }
    },
  );
}
