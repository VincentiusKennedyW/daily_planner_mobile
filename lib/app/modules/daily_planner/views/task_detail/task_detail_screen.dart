import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/task_detail_header.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/task_info_card.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/widgets/comment_section.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskListModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // final CommentTaskController _commentTaskController =
  //     Get.find<CommentTaskController>();

  CommentTaskController get _commentTaskController =>
      Get.find<CommentTaskController>();

  @override
  void initState() {
    super.initState();
    _commentTaskController.setCurrentTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TaskDetailHeader(
        task: _commentTaskController.currentTask.value ?? widget.task,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() =>
                TaskInfoCard(task: _commentTaskController.currentTask.value)),
            SizedBox(height: 16),
            CommentSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
