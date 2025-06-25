import 'dart:convert';

import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/assign_to_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/complete_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/start_task_controller.dart';
import 'package:expense_tracker/core/helper/format_date_helper.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/global_widgets/custom_confirmation_dialog.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class TaskCard extends StatelessWidget {
  final TaskListModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final StartTaskController startTaskController =
        Get.find<StartTaskController>();
    final CompleteTaskController completeTaskController =
        Get.find<CompleteTaskController>();
    final AssignToTaskController assignToTaskController =
        Get.find<AssignToTaskController>();
    final GetStorage storage = GetStorage();

    String? userDataResponse = storage.read('user_data');
    String userId = '0';

    if (userDataResponse != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataResponse);
      userId = userData['id']?.toString() ?? '0';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: task.category.color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: task.status == TaskStatus.overdue
              ? Colors.red.withOpacity(0.3)
              : task.category.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/task-detail', arguments: task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: task.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      task.category.icon,
                      color: task.category.color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          task.category.name,
                          style: TextStyle(
                            color: task.category.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          task.comments?.length.toString() ?? '0',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.priority.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority.name,
                      style: TextStyle(
                        color: task.priority.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.status.name,
                      style: TextStyle(
                        color: task.status.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  if (task.status == TaskStatus.overdue)
                    Icon(Icons.warning_rounded, color: Colors.red, size: 16),
                  if (task.dueDate != null) ...[
                    Icon(Icons.schedule_rounded,
                        color: Colors.grey[500], size: 14),
                    SizedBox(width: 4),
                    Text(
                      formatDate(task.dueDate!),
                      style: TextStyle(
                        color: task.status == TaskStatus.overdue
                            ? Colors.red
                            : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.assignees!.map((assignee) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    Color(0xFF6366F1).withOpacity(0.1),
                                child: Text(
                                  assignee.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Color(0xFF6366F1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                assignee.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${task.category.points} poin',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Hide buttons when task is completed
              if (task.status != TaskStatus.completed) ...[
                if (task.assignees
                        ?.any((assignee) => assignee.id.toString() == userId) !=
                    true) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ConfirmationDialogHelper.show(
                              title: 'Assign Task',
                              message:
                                  'Apakah Anda yakin ingin assign task ini ke diri Anda sendiri?',
                              confirmText: 'Ya, Assign',
                              cancelText: 'Batal',
                              icon: Icons.person_add_rounded,
                              iconColor: Color(0xFF6366F1),
                              confirmButtonColor: Color(0xFF6366F1),
                              onConfirm: () async {
                                final success = await assignToTaskController
                                    .assignToTask(task.id);
                                if (success) {
                                  showCustomSnackbar(
                                    isSuccess: true,
                                    title: 'Berhasil!',
                                    message:
                                        'Anda telah berhasil assign task "${task.title}"',
                                  );
                                } else {
                                  showCustomSnackbar(
                                    isSuccess: false,
                                    title: 'Ups, Ada Masalah!',
                                    message: assignToTaskController
                                        .errorMessage.value,
                                  );
                                }
                              },
                            );
                          },
                          icon: Icon(Icons.person_add_rounded, size: 16),
                          label:
                              Text('Assign Me', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                            foregroundColor: Color(0xFF6366F1),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (task.status == TaskStatus.todo)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ConfirmationDialogHelper.show(
                                title: 'Mulai Task',
                                message:
                                    'Apakah Anda yakin ingin memulai task ini?',
                                confirmText: 'Ya, Mulai',
                                cancelText: 'Batal',
                                icon: Icons.play_arrow_rounded,
                                iconColor: Colors.blue,
                                confirmButtonColor: Colors.blue,
                                onConfirm: () async {
                                  final success =
                                      await startTaskController.startTask(
                                    task.id,
                                  );
                                  if (success) {
                                    showCustomSnackbar(
                                      isSuccess: true,
                                      title: 'Berhasil!',
                                      message:
                                          'Task "${task.title}" telah dimulai',
                                    );
                                  } else {
                                    showCustomSnackbar(
                                      isSuccess: false,
                                      title: 'Ups, Ada Masalah!',
                                      message: startTaskController
                                          .errorMessage.value,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.play_arrow_rounded, size: 16),
                            label:
                                Text('Mulai', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              foregroundColor: Colors.blue,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      if (task.status == TaskStatus.inProgress)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ConfirmationDialogHelper.show(
                                title: 'Selesaikan Task',
                                message:
                                    'Apakah Anda yakin ingin menyelesaikan task ini?',
                                confirmText: 'Ya, Selesai',
                                cancelText: 'Batal',
                                icon: Icons.check_rounded,
                                iconColor: Colors.green,
                                confirmButtonColor: Colors.green,
                                onConfirm: () async {
                                  final success =
                                      await completeTaskController.completeTask(
                                    task.id,
                                  );
                                  if (success) {
                                    showCustomSnackbar(
                                      isSuccess: true,
                                      title: 'Berhasil!',
                                      message:
                                          'Task "${task.title}" telah selesai',
                                    );
                                  } else {
                                    showCustomSnackbar(
                                      isSuccess: false,
                                      title: 'Ups, Ada Masalah!',
                                      message: completeTaskController
                                          .errorMessage.value,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.check_rounded, size: 16),
                            label:
                                Text('Selesai', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.1),
                              foregroundColor: Colors.green,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                if (task.assignees
                        ?.any((assignee) => assignee.id.toString() == userId) ==
                    true) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ConfirmationDialogHelper.show(
                              title: 'Unassign Task',
                              message:
                                  'Apakah Anda yakin ingin menghapus diri Anda dari task ini?',
                              confirmText: 'Ya, Hapus',
                              cancelText: 'Batal',
                              icon: Icons.person_remove_rounded,
                              iconColor: Colors.red,
                              confirmButtonColor: Colors.red,
                              onConfirm: () async {
                                final success = await assignToTaskController
                                    .unassignFromTask(
                                  task.id,
                                );
                                if (success) {
                                  showCustomSnackbar(
                                    isSuccess: true,
                                    title: 'Berhasil!',
                                    message:
                                        'Anda telah berhasil menghapus diri dari task "${task.title}"',
                                  );
                                } else {
                                  showCustomSnackbar(
                                    isSuccess: false,
                                    title: 'Ups, Ada Masalah!',
                                    message: assignToTaskController
                                        .errorMessage.value,
                                  );
                                }
                              },
                            );
                          },
                          icon: Icon(Icons.person_remove_rounded, size: 16),
                          label: Text('Unassign Me',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.red,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (task.status == TaskStatus.todo)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ConfirmationDialogHelper.show(
                                title: 'Mulai Task',
                                message:
                                    'Apakah Anda yakin ingin memulai task ini?',
                                confirmText: 'Ya, Mulai',
                                cancelText: 'Batal',
                                icon: Icons.play_arrow_rounded,
                                iconColor: Colors.blue,
                                confirmButtonColor: Colors.blue,
                                onConfirm: () async {
                                  final success =
                                      await startTaskController.startTask(
                                    task.id,
                                  );
                                  if (success) {
                                    showCustomSnackbar(
                                      isSuccess: true,
                                      title: 'Berhasil!',
                                      message:
                                          'Task "${task.title}" telah dimulai',
                                    );
                                  } else {
                                    showCustomSnackbar(
                                      isSuccess: false,
                                      title: 'Ups, Ada Masalah!',
                                      message: startTaskController
                                          .errorMessage.value,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.play_arrow_rounded, size: 16),
                            label:
                                Text('Mulai', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              foregroundColor: Colors.blue,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      if (task.status == TaskStatus.inProgress)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ConfirmationDialogHelper.show(
                                title: 'Selesaikan Task',
                                message:
                                    'Apakah Anda yakin ingin menyelesaikan task ini?',
                                confirmText: 'Ya, Selesai',
                                cancelText: 'Batal',
                                icon: Icons.check_rounded,
                                iconColor: Colors.green,
                                confirmButtonColor: Colors.green,
                                onConfirm: () async {
                                  final success =
                                      await completeTaskController.completeTask(
                                    task.id,
                                  );
                                  if (success) {
                                    showCustomSnackbar(
                                      isSuccess: true,
                                      title: 'Berhasil!',
                                      message:
                                          'Task "${task.title}" telah selesai',
                                    );
                                  } else {
                                    showCustomSnackbar(
                                      isSuccess: false,
                                      title: 'Ups, Ada Masalah!',
                                      message: completeTaskController
                                          .errorMessage.value,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.check_rounded, size: 16),
                            label:
                                Text('Selesai', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.1),
                              foregroundColor: Colors.green,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
