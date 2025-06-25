import 'package:flutter/material.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/task_card.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/task_list_bottom_loader.dart';
import 'package:expense_tracker/core/task.dart';

Widget buildTaskList(
  List<TaskListModel> tasks,
  bool isLoading,
  bool isLoadMore,
  String errorMessage,
  VoidCallback onRefresh,
  ScrollController scrollController,
  TaskStatus status,
) {
  if (isLoading) {
    return Center(child: CircularProgressIndicator());
  }

  if (errorMessage.isNotEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            'Error: $errorMessage',
            style: TextStyle(color: Colors.red[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  if (tasks.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada task',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Task akan muncul di sini',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    children: [
      // Informasi pagination di bagian atas
      // Obx(() => PaginationInfo(
      //       pagination: _getPaginationByStatus(status),
      //       status: status,
      //     )),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: tasks.length + 1,
            itemBuilder: (context, index) {
              if (index < tasks.length) {
                return TaskCard(
                  task: tasks[index],
                );
              } else {
                return buildBottomLoader(isLoadMore, status);
              }
            },
          ),
        ),
      ),
    ],
  );
}
