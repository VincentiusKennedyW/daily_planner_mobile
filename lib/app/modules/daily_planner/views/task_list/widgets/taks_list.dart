import 'package:flutter/material.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/widgets/empty_projects_view.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/widgets/project_error_view.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/task_card.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/task_list_bottom_loader.dart';
import 'package:expense_tracker/core/task.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskListModel> tasks;
  final bool isLoading;
  final bool isLoadMore;
  final String errorMessage;
  final VoidCallback onRefresh;
  final ScrollController scrollController;
  final TaskStatus status;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.isLoadMore,
    required this.errorMessage,
    required this.onRefresh,
    required this.scrollController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return ProjectOrTaskErrorView(
          isTaskError: true,
          errorMessage: errorMessage,
          onRetry: () {
            onRefresh();
          });
    }

    if (tasks.isEmpty) {
      return EmptyTaskOrProjectView(
        isTaskView: true,
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
}
