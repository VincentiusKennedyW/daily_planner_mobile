import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/core/helper/format_date_helper.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskListModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final GetStorage _storage = GetStorage();

  final CommentTaskController _commentTaskController =
      Get.find<CommentTaskController>();

  bool isAddingComment = false;

  @override
  void initState() {
    super.initState();
    _commentTaskController.setCurrentTask(widget.task);
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final success = await _commentTaskController.addComment(
      _commentController.text.trim(),
    );

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
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
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey[800]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _commentTaskController.currentTask.value?.status ==
                            TaskStatus.overdue
                        ? Colors.red.withOpacity(0.1)
                        : (_commentTaskController
                                    .currentTask.value?.category.color ??
                                Colors.grey)
                            .withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _commentTaskController.currentTask.value?.status ==
                          TaskStatus.overdue
                      ? Colors.red.withOpacity(0.3)
                      : (_commentTaskController
                                  .currentTask.value?.category.color ??
                              Colors.grey)
                          .withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _commentTaskController
                                  .currentTask.value?.category.color
                                  .withOpacity(0.1) ??
                              Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _commentTaskController
                                  .currentTask.value?.category.icon ??
                              Icons.category_rounded,
                          color: _commentTaskController
                                  .currentTask.value?.category.color ??
                              Colors.grey[800],
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _commentTaskController
                                      .currentTask.value?.category.name ??
                                  'Tanpa Kategori',
                              style: TextStyle(
                                color: _commentTaskController
                                        .currentTask.value?.category.color ??
                                    Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_commentTaskController.currentTask.value?.point ?? 0} poin',
                              style: TextStyle(
                                color: Color(0xFF6366F1),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Dibuat oleh ${_commentTaskController.currentTask.value?.creator.name}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Text(
                        formatDateWithTime(_commentTaskController
                            .currentTask.value!.createdAt),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    _commentTaskController.currentTask.value?.title ??
                        'Tanpa Judul',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey[800],
                      decoration:
                          _commentTaskController.currentTask.value?.status ==
                                  TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  if (_commentTaskController
                      .currentTask.value!.description.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(
                      _commentTaskController.currentTask.value!.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _commentTaskController
                              .currentTask.value?.priority.color
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _commentTaskController
                              .currentTask.value!.priority.name,
                          style: TextStyle(
                            color: _commentTaskController
                                .currentTask.value?.priority.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _commentTaskController
                              .currentTask.value?.status.color
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _commentTaskController.currentTask.value!.status.name,
                          style: TextStyle(
                            color: _commentTaskController
                                .currentTask.value?.status.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Spacer(),
                      if (_commentTaskController.currentTask.value?.status ==
                          TaskStatus.overdue)
                        Icon(Icons.warning_rounded,
                            color: Colors.red, size: 20),
                    ],
                  ),
                  if (_commentTaskController.currentTask.value?.dueDate !=
                      null) ...[
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            color: Colors.grey[500], size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Deadline: ${formatDate(_commentTaskController.currentTask.value!.dueDate!)}',
                          style: TextStyle(
                            color: _commentTaskController
                                        .currentTask.value?.status ==
                                    TaskStatus.overdue
                                ? Colors.red
                                : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_commentTaskController.currentTask.value?.assignees !=
                          null &&
                      _commentTaskController
                          .currentTask.value!.assignees!.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'Assignees',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commentTaskController
                          .currentTask.value!.assignees!
                          .map((assignee) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFF6366F1),
                                child: Text(
                                  assignee.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
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
                                  color: Color(0xFF6366F1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 16),

            // _buildActionButtons(),

            SizedBox(height: 16),

            Obx(() => _buildCommentSection()),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
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
          Row(
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
          ),
          SizedBox(height: 16),
          Container(
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (_commentTaskController.isLoadingComment.value)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
            )
          else if (_commentTaskController
                  .currentTask.value?.comments?.isEmpty ??
              true)
            Center(
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
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  _commentTaskController.currentTask.value?.comments?.length ??
                      0,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final comment =
                    _commentTaskController.currentTask.value!.comments![index];

                String? userDataResponse = _storage.read('user_data');
                String userId = '0';

                if (userDataResponse != null) {
                  final Map<String, dynamic> userData =
                      jsonDecode(userDataResponse);
                  userId = userData['id']?.toString() ?? '0';
                }
                final isMyComment = comment.user.id == int.tryParse(userId);

                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMyComment
                        ? Color(0xFF6366F1).withOpacity(0.05)
                        : Colors.grey[50],
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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: isMyComment
                                ? Color(0xFF6366F1)
                                : Colors.grey[400],
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                            GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Hapus Komentar'),
                                    content: Text(
                                        'Apakah Anda yakin ingin menghapus komentar ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final success = await _commentTaskController
                                      .deleteComment(comment.id);
                                  if (!success) {
                                    showCustomSnackbar(
                                      isSuccess: false,
                                      title: 'Ups, Ada Masalah!',
                                      message: _commentTaskController
                                          .errorMessage.value,
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
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        comment.content,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
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


  // Widget _buildActionButtons() {
  //   final isAssigned = currentTask.assignees
  //           ?.any((assignee) => assignee.id.toString() == userId) ==
  //       true;

  //   if (currentTask.status == TaskStatus.completed) {
  //     return SizedBox.shrink();
  //   }

  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     padding: EdgeInsets.all(20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Aksi',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         if (!isAssigned) ...[
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton.icon(
  //               onPressed: () async {
  //                 await ConfirmationDialogHelper.show(
  //                   title: 'Assign Task',
  //                   message:
  //                       'Apakah Anda yakin ingin assign task ini ke diri Anda sendiri?',
  //                   confirmText: 'Ya, Assign',
  //                   cancelText: 'Batal',
  //                   icon: Icons.person_add_rounded,
  //                   iconColor: Color(0xFF6366F1),
  //                   confirmButtonColor: Color(0xFF6366F1),
  //                   onConfirm: () async {
  //                     final success = await assignToTaskController
  //                         .assignToTask(currentTask.id);
  //                     if (success) {
  //                       showCustomSnackbar(
  //                         isSuccess: true,
  //                         title: 'Berhasil!',
  //                         message:
  //                             'Anda telah berhasil assign task "${currentTask.title}"',
  //                       );
  //                       // Refresh task data
  //                       setState(() {
  //                         // Update assignees - ini perlu disesuaikan dengan struktur data Anda
  //                       });
  //                     } else {
  //                       showCustomSnackbar(
  //                         isSuccess: false,
  //                         title: 'Ups, Ada Masalah!',
  //                         message: assignToTaskController.errorMessage.value,
  //                       );
  //                     }
  //                   },
  //                 );
  //               },
  //               icon: Icon(Icons.person_add_rounded),
  //               label: Text('Assign ke Saya'),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Color(0xFF6366F1),
  //                 foregroundColor: Colors.white,
  //                 padding: EdgeInsets.symmetric(vertical: 12),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ] else ...[
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton.icon(
  //               onPressed: () async {
  //                 await ConfirmationDialogHelper.show(
  //                   title: 'Unassign Task',
  //                   message:
  //                       'Apakah Anda yakin ingin menghapus diri Anda dari task ini?',
  //                   confirmText: 'Ya, Hapus',
  //                   cancelText: 'Batal',
  //                   icon: Icons.person_remove_rounded,
  //                   iconColor: Colors.red,
  //                   confirmButtonColor: Colors.red,
  //                   onConfirm: () async {
  //                     final success = await assignToTaskController
  //                         .unassignFromTask(currentTask.id);
  //                     if (success) {
  //                       showCustomSnackbar(
  //                         isSuccess: true,
  //                         title: 'Berhasil!',
  //                         message:
  //                             'Anda telah berhasil menghapus diri dari task "${currentTask.title}"',
  //                       );
  //                       // Refresh task data
  //                       setState(() {
  //                         // Update assignees - ini perlu disesuaikan dengan struktur data Anda
  //                       });
  //                     } else {
  //                       showCustomSnackbar(
  //                         isSuccess: false,
  //                         title: 'Ups, Ada Masalah!',
  //                         message: assignToTaskController.errorMessage.value,
  //                       );
  //                     }
  //                   },
  //                 );
  //               },
  //               icon: Icon(Icons.person_remove_rounded),
  //               label: Text('Unassign dari Saya'),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.red,
  //                 foregroundColor: Colors.white,
  //                 padding: EdgeInsets.symmetric(vertical: 12),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 12),
  //           if (currentTask.status == TaskStatus.todo)
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton.icon(
  //                 onPressed: () async {
  //                   await ConfirmationDialogHelper.show(
  //                     title: 'Mulai Task',
  //                     message: 'Apakah Anda yakin ingin memulai task ini?',
  //                     confirmText: 'Ya, Mulai',
  //                     cancelText: 'Batal',
  //                     icon: Icons.play_arrow_rounded,
  //                     iconColor: Colors.blue,
  //                     confirmButtonColor: Colors.blue,
  //                     onConfirm: () async {
  //                       final success =
  //                           await startTaskController.startTask(currentTask.id);
  //                       if (success) {
  //                         showCustomSnackbar(
  //                           isSuccess: true,
  //                           title: 'Berhasil!',
  //                           message:
  //                               'Task "${currentTask.title}" telah dimulai',
  //                         );
  //                         setState(() {
  //                           // Update status - ini perlu disesuaikan dengan struktur data Anda
  //                         });
  //                       } else {
  //                         showCustomSnackbar(
  //                           isSuccess: false,
  //                           title: 'Ups, Ada Masalah!',
  //                           message: startTaskController.errorMessage.value,
  //                         );
  //                       }
  //                     },
  //                   );
  //                 },
  //                 icon: Icon(Icons.play_arrow_rounded),
  //                 label: Text('Mulai Task'),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.blue,
  //                   foregroundColor: Colors.white,
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           if (currentTask.status == TaskStatus.inProgress)
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton.icon(
  //                 onPressed: () async {
  //                   await ConfirmationDialogHelper.show(
  //                     title: 'Selesaikan Task',
  //                     message:
  //                         'Apakah Anda yakin ingin menyelesaikan task ini?',
  //                     confirmText: 'Ya, Selesai',
  //                     cancelText: 'Batal',
  //                     icon: Icons.check_rounded,
  //                     iconColor: Colors.green,
  //                     confirmButtonColor: Colors.green,
  //                     onConfirm: () async {
  //                       final success = await completeTaskController
  //                           .completeTask(currentTask.id);
  //                       if (success) {
  //                         showCustomSnackbar(
  //                           isSuccess: true,
  //                           title: 'Berhasil!',
  //                           message:
  //                               'Task "${currentTask.title}" telah selesai',
  //                         );
  //                         setState(() {
  //                           // Update status - ini perlu disesuaikan dengan struktur data Anda
  //                         });
  //                       } else {
  //                         showCustomSnackbar(
  //                           isSuccess: false,
  //                           title: 'Ups, Ada Masalah!',
  //                           message: completeTaskController.errorMessage.value,
  //                         );
  //                       }
  //                     },
  //                   );
  //                 },
  //                 icon: Icon(Icons.check_rounded),
  //                 label: Text('Selesaikan Task'),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.green,
  //                   foregroundColor: Colors.white,
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ],
  //     ),
  //   );
  // }