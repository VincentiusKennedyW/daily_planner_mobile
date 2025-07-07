import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_list/project_list_screen.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/task_list_screen.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/widgets/view_toggle_switch.dart';
import 'package:expense_tracker/core/task.dart';

class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  _DailyPlannerScreenState createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final GetTaskController getTaskController = Get.find<GetTaskController>();
  final GetProjectController getProjectController =
      Get.find<GetProjectController>();

  final ScrollController _todoScrollController = ScrollController();
  final ScrollController _inProgressScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  final ScrollController _projectScrollController = ScrollController();
  // final ScrollController _blockedScrollController = ScrollController();

  // Toggle between Project and Task view
  bool _isProjectView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _setupScrollListeners();
  }

  void _setupScrollListeners() {
    _todoScrollController.addListener(() {
      if (_todoScrollController.position.pixels >=
          _todoScrollController.position.maxScrollExtent - 100) {
        if (getTaskController.canLoadMoreTodo()) {
          getTaskController.loadMoreTaskByStatus(TaskStatus.todo);
        }
      }
    });

    _inProgressScrollController.addListener(() {
      if (_inProgressScrollController.position.pixels >=
          _inProgressScrollController.position.maxScrollExtent - 100) {
        if (getTaskController.canLoadMoreInProgress()) {
          getTaskController.loadMoreTaskByStatus(TaskStatus.inProgress);
        }
      }
    });

    _completedScrollController.addListener(() {
      if (_completedScrollController.position.pixels >=
          _completedScrollController.position.maxScrollExtent - 100) {
        if (getTaskController.canLoadMoreCompleted()) {
          getTaskController.loadMoreTaskByStatus(TaskStatus.completed);
        }
      }
    });

    _projectScrollController.addListener(() {
      if (_projectScrollController.position.pixels >=
          _projectScrollController.position.maxScrollExtent - 100) {
        if (getProjectController.hasNextPage) {
          getProjectController.loadMoreProjects();
        }
      }
    });

    // _blockedScrollController.addListener(() {
    //   if (_blockedScrollController.position.pixels >=
    //       _blockedScrollController.position.maxScrollExtent - 100) {
    //     if (getTaskController.canLoadMoreBlocked()) {
    //       getTaskController.loadMoreTaskByStatus(TaskStatus.blocked);
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _todoScrollController.dispose();
    _inProgressScrollController.dispose();
    _completedScrollController.dispose();
    _projectScrollController.dispose();
    // _blockedScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planning Harian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: _isProjectView
            ? null
            : TaskTabBar(
                tabController: _tabController,
                controller: getTaskController,
              ),
        actions: [
          ViewToggleSwitch(
            isProjectView: _isProjectView,
            onChanged: (value) {
              setState(() {
                _isProjectView = value;
              });
            },
          ),
        ],
      ),
      body: _isProjectView ? _buildProjectView() : _buildTaskView(),
    );
  }

  Widget _buildTaskView() {
    return TaskListView(
      tabController: _tabController,
      controller: getTaskController,
      todoScrollController: _todoScrollController,
      inProgressScrollController: _inProgressScrollController,
      completedScrollController: _completedScrollController,
    );
  }

  Widget _buildProjectView() {
    return ProjectListView(
      scrollController: _projectScrollController,
      controller: getProjectController,
    );
  }

}
