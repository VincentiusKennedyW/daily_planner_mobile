import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/daily_plan_list/widgets/taks_list.dart';
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

  final GetTaskController getTaskController = Get.find<GetTaskController>();

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

    _blockedScrollController.addListener(() {
      if (_blockedScrollController.position.pixels >=
          _blockedScrollController.position.maxScrollExtent - 100) {
        if (getTaskController.canLoadMoreBlocked()) {
          getTaskController.loadMoreTaskByStatus(TaskStatus.blocked);
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
                getTaskController.todoTasks,
                getTaskController.isTodoLoading.value,
                getTaskController.isTodoPaginationLoading.value,
                getTaskController.todoError.value,
                () => getTaskController.refreshTab(TaskStatus.todo),
                _todoScrollController,
                TaskStatus.todo,
              )),
          Obx(() => buildTaskList(
                getTaskController.inProgressTasks,
                getTaskController.isInProgressLoading.value,
                getTaskController.isInProgressPaginationLoading.value,
                getTaskController.inProgressError.value,
                () => getTaskController.refreshTab(TaskStatus.inProgress),
                _inProgressScrollController,
                TaskStatus.inProgress,
              )),
          Obx(() => buildTaskList(
                getTaskController.completedTasks,
                getTaskController.isCompletedLoading.value,
                getTaskController.isCompletedPaginationLoading.value,
                getTaskController.completedError.value,
                () => getTaskController.refreshTab(TaskStatus.completed),
                _completedScrollController,
                TaskStatus.completed,
              )),
          Obx(() => buildTaskList(
                getTaskController.blockedTasks,
                getTaskController.isBlockedLoading.value,
                getTaskController.isBlockedPaginationLoading.value,
                getTaskController.blockedError.value,
                () => getTaskController.refreshTab(TaskStatus.blocked),
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
        return getTaskController.todoPagination.value;
      case TaskStatus.inProgress:
        return getTaskController.inProgressPagination.value;
      case TaskStatus.completed:
        return getTaskController.completedPagination.value;
      case TaskStatus.blocked:
        return getTaskController.blockedPagination.value;
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