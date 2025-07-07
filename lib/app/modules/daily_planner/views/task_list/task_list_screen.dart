import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/taks_list.dart';
import 'package:expense_tracker/core/task.dart';

class TaskListView extends StatelessWidget {
  final TabController tabController;
  final GetTaskController controller;
  final ScrollController todoScrollController;
  final ScrollController inProgressScrollController;
  final ScrollController completedScrollController;

  const TaskListView({
    super.key,
    required this.tabController,
    required this.controller,
    required this.todoScrollController,
    required this.inProgressScrollController,
    required this.completedScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Obx(() => TaskListWidget(
              tasks: controller.todoTasks,
              isLoading: controller.isTodoLoading.value,
              isLoadMore: controller.isTodoPaginationLoading.value,
              errorMessage: controller.todoError.value,
              onRefresh: () => controller.refreshTab(TaskStatus.todo),
              scrollController: todoScrollController,
              status: TaskStatus.todo,
            )),
        Obx(() => TaskListWidget(
              tasks: controller.inProgressTasks,
              isLoading: controller.isInProgressLoading.value,
              isLoadMore: controller.isInProgressPaginationLoading.value,
              errorMessage: controller.inProgressError.value,
              onRefresh: () => controller.refreshTab(TaskStatus.inProgress),
              scrollController: inProgressScrollController,
              status: TaskStatus.inProgress,
            )),
        Obx(() => TaskListWidget(
              tasks: controller.completedTasks,
              isLoading: controller.isCompletedLoading.value,
              isLoadMore: controller.isCompletedPaginationLoading.value,
              errorMessage: controller.completedError.value,
              onRefresh: () => controller.refreshTab(TaskStatus.completed),
              scrollController: completedScrollController,
              status: TaskStatus.completed,
            )),
      ],
    );
  }
}

class TaskTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final GetTaskController controller;

  const TaskTabBar({
    super.key,
    required this.tabController,
    required this.controller,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Color(0xFF6366F1),
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Color(0xFF6366F1),
      tabs: [
        Obx(() => Tab(
            text:
                'To Do (${_getPaginationByStatus(TaskStatus.todo)?.total ?? 0})')),
        Obx(() => Tab(
            text:
                'Progress (${_getPaginationByStatus(TaskStatus.inProgress)?.total ?? 0})')),
        Obx(() => Tab(
            text:
                'Done (${_getPaginationByStatus(TaskStatus.completed)?.total ?? 0})')),
      ],
    );
  }

  Pagination? _getPaginationByStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return controller.todoPagination.value;
      case TaskStatus.inProgress:
        return controller.inProgressPagination.value;
      case TaskStatus.completed:
        return controller.completedPagination.value;
      default:
        return null;
    }
  }
}
