import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/project_detail_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/empty_task_view.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/widgets/task_card.dart';

class ProjectTaskTabs extends StatefulWidget {
  final ProjectDetailController controller;

  const ProjectTaskTabs({super.key, required this.controller});

  @override
  State<ProjectTaskTabs> createState() => _ProjectTaskTabsState();
}

class _ProjectTaskTabsState extends State<ProjectTaskTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.controller.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabBar(),
          _buildTabBarView(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6366F1),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Todo'),
                  if (widget.controller.todoCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.controller.todoCount.toString(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Progress'),
                  if (widget.controller.inProgressCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.controller.inProgressCount.toString(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Done'),
                  if ((widget.controller.completedCount +
                          widget.controller.blockedCount) >
                      0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        (widget.controller.completedCount +
                                widget.controller.blockedCount)
                            .toString(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 400,
      child: Obx(() {
        return TabBarView(
          controller: _tabController,
          children: [
            _buildTaskList(widget.controller.todoTasksForProject),
            _buildTaskList(widget.controller.inProgressTasksForProject),
            _buildTaskList([
              ...widget.controller.completedTasksForProject,
              ...widget.controller.blockedTasksForProject,
            ]),
          ],
        );
      }),
    );
  }

  Widget _buildTaskList(List tasks) {
    if (tasks.isEmpty) {
      return EmptyTaskView(
        message: "Tidak ada Task",
        icon: Icons.assignment_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: tasks[index]);
      },
    );
  }
}
