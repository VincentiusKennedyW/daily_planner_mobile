import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/components/taks_list.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/task_controller.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';

class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  _DailyPlannerScreenState createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final TaskController taskController = Get.find<TaskController>();

  final ScrollController _todoScrollController = ScrollController();
  final ScrollController _inProgressScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  final ScrollController _blockedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _setupScrollListeners();
  }

  void _setupScrollListeners() {
    _todoScrollController.addListener(() {
      if (_todoScrollController.position.pixels >=
          _todoScrollController.position.maxScrollExtent - 100) {
        if (taskController.canLoadMoreTodo()) {
          taskController.loadMoreTaskByStatus(TaskStatus.todo);
        }
      }
    });

    _inProgressScrollController.addListener(() {
      if (_inProgressScrollController.position.pixels >=
          _inProgressScrollController.position.maxScrollExtent - 100) {
        if (taskController.canLoadMoreInProgress()) {
          taskController.loadMoreTaskByStatus(TaskStatus.inProgress);
        }
      }
    });

    _completedScrollController.addListener(() {
      if (_completedScrollController.position.pixels >=
          _completedScrollController.position.maxScrollExtent - 100) {
        if (taskController.canLoadMoreCompleted()) {
          taskController.loadMoreTaskByStatus(TaskStatus.completed);
        }
      }
    });

    _blockedScrollController.addListener(() {
      if (_blockedScrollController.position.pixels >=
          _blockedScrollController.position.maxScrollExtent - 100) {
        if (taskController.canLoadMoreBlocked()) {
          taskController.loadMoreTaskByStatus(TaskStatus.blocked);
        }
      }
    });
  }

  @override
  void dispose() {
    _todoScrollController.dispose();
    _inProgressScrollController.dispose();
    _completedScrollController.dispose();
    _blockedScrollController.dispose();
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
        bottom: TabBar(
          controller: _tabController,
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
            Obx(() => Tab(
                text:
                    'Blocked (${_getPaginationByStatus(TaskStatus.blocked)?.total ?? 0})')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(() => buildTaskList(
                taskController.todoTasks,
                taskController.isTodoLoading.value,
                taskController.isTodoPaginationLoading.value,
                taskController.todoError.value,
                () => taskController.refreshTab(TaskStatus.todo),
                _todoScrollController,
                TaskStatus.todo,
              )),
          Obx(() => buildTaskList(
                taskController.inProgressTasks,
                taskController.isInProgressLoading.value,
                taskController.isInProgressPaginationLoading.value,
                taskController.inProgressError.value,
                () => taskController.refreshTab(TaskStatus.inProgress),
                _inProgressScrollController,
                TaskStatus.inProgress,
              )),
          Obx(() => buildTaskList(
                taskController.completedTasks,
                taskController.isCompletedLoading.value,
                taskController.isCompletedPaginationLoading.value,
                taskController.completedError.value,
                () => taskController.refreshTab(TaskStatus.completed),
                _completedScrollController,
                TaskStatus.completed,
              )),
          Obx(() => buildTaskList(
                taskController.blockedTasks,
                taskController.isBlockedLoading.value,
                taskController.isBlockedPaginationLoading.value,
                taskController.blockedError.value,
                () => taskController.refreshTab(TaskStatus.blocked),
                _blockedScrollController,
                TaskStatus.blocked,
              )),
        ],
      ),
    );
  }

  Pagination? _getPaginationByStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return taskController.todoPagination.value;
      case TaskStatus.inProgress:
        return taskController.inProgressPagination.value;
      case TaskStatus.completed:
        return taskController.completedPagination.value;
      case TaskStatus.blocked:
        return taskController.blockedPagination.value;
      default:
        return null;
    }
  }

  void _showAddCommentDialog(Task task) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Komentar'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Tulis komentar...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                TaskManager.addComment(
                  task.id,
                  TaskComment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    author: TaskManager.currentUser,
                    content: commentController.text,
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskManager.userNames.map((user) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                foregroundColor: Color(0xFF6366F1),
                child: Text(user[0]),
              ),
              title: Text(user),
              onTap: () {
                setState(() {
                  TaskManager.assignTask(task.id, user);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Task'),
        content: Text('Apakah Anda yakin ingin menghapus task ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                TaskManager.removeTask(task.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}


  // void _showEditTaskDialog(Task task) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => EditTaskSheet(task: task),
  //   );
  // }

    // void _showTaskDetail(TaskListModel task) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => TaskDetailSheet(task: task),
  //   );
  // }

  // void _handleTaskAction(Task task, String action) {
  //   switch (action) {
  //     case 'edit':
  //       _showEditTaskDialog(task);
  //       break;
  //     case 'comment':
  //       _showAddCommentDialog(task);
  //       break;
  //     case 'assign':
  //       _showAssignDialog(task);
  //       break;
  //     case 'delete':
  //       _showDeleteConfirmation(task);
  //       break;
  //   }
  // }