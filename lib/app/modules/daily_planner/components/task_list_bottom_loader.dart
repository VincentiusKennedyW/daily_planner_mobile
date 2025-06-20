import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildBottomLoader(bool isLoadingMore, TaskStatus status) {
  final getTaskController = Get.find<GetTaskController>();

  if (!isLoadingMore) {
    bool hasMore = false;
    switch (status) {
      case TaskStatus.todo:
        hasMore = getTaskController.canLoadMoreTodo();
        break;
      case TaskStatus.inProgress:
        hasMore = getTaskController.canLoadMoreInProgress();
        break;
      case TaskStatus.completed:
        hasMore = getTaskController.canLoadMoreCompleted();
        break;
      case TaskStatus.blocked:
        hasMore = getTaskController.canLoadMoreBlocked();
        break;
      case TaskStatus.cancelled:
        throw UnimplementedError();
      case TaskStatus.overdue:
        throw UnimplementedError();
      case TaskStatus.onReview:
        throw UnimplementedError();
      case TaskStatus.onHold:
        throw UnimplementedError();
    }

    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Tidak ada data lagi',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(height: 8),
          Text(
            'Memuat data...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
