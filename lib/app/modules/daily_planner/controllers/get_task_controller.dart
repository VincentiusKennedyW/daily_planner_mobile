import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/task_response.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/helper/task_helper.dart';
import 'package:expense_tracker/core/task.dart';

class GetTaskController extends GetxController with TaskHelpers {
  final RxList<TaskListModel> todoTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> inProgressTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> completedTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> blockedTasks = <TaskListModel>[].obs;

  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  @override
  void onInit() {
    super.onInit();
    loadAllTabs();
  }

  Future<void> loadAllTabs() async {
    await Future.wait([
      getTasksByStatus(TaskStatus.todo),
      getTasksByStatus(TaskStatus.inProgress),
      getTasksByStatus(TaskStatus.completed),
      // getTasksByStatus(TaskStatus.blocked),
    ]);
  }

  Future<void> getTasksByStatus(
    TaskStatus status, {
    int page = 1,
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        setPaginationLoadingState(status, true);
      } else {
        setLoadingState(status, true);
        setErrorMessage(status, '');
      }

      final url =
          '$baseUrl/tasks?page=$page&limit=$limit&status=${status.name}';
      final token = _storage.read('token');

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final taskResponse =
            GetAllTasksResponse.fromJson(json.decode(response.body));

        if (taskResponse.status == 'success') {
          if (isLoadMore) {
            _appendTasksByStatus(status, taskResponse.data?.tasks ?? []);
          } else {
            _updateTasksByStatus(status, taskResponse.data?.tasks ?? []);
          }
          updatePagination(
              status, taskResponse.data?.pagination ?? Pagination());
        } else {
          setErrorMessage(status, taskResponse.message);
        }
      } else {
        setErrorMessage(status, 'HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      setErrorMessage(status, 'Failed to load tasks: $e');
    } finally {
      if (isLoadMore) {
        setPaginationLoadingState(status, false);
      } else {
        setLoadingState(status, false);
      }
    }
  }

  Future<void> loadMoreTaskByStatus(TaskStatus status) async {
    final pagination = getPagination(status);
    if (!hasNextPage(pagination)) return;
    final nextPage = (pagination?.page ?? 0) + 1;
    await getTasksByStatus(status, page: nextPage, isLoadMore: true);
  }

  void _updateTasksByStatus(TaskStatus status, List<TaskListModel> tasks) {
    _getTaskListByStatus(status).assignAll(tasks);
  }

  void _appendTasksByStatus(TaskStatus status, List<TaskListModel> newTasks) {
    _getTaskListByStatus(status).addAll(newTasks);
  }

  Future<void> refreshTab(TaskStatus status) async {
    await getTasksByStatus(status);
  }

  RxList<TaskListModel> _getTaskListByStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return todoTasks;
      case TaskStatus.inProgress:
        return inProgressTasks;
      case TaskStatus.completed:
        return completedTasks;
      case TaskStatus.blocked:
        return blockedTasks;
      default:
        return todoTasks;
    }
  }

  void updateTaskInList(TaskListModel updatedTask) {
    TaskListModel? currentTask = findTaskById(updatedTask.id);
    if (currentTask == null) return;

    if (currentTask.status == updatedTask.status) {
      _updateTaskInPlace(updatedTask);
    } else {
      _removeTaskFromAllLists(updatedTask.id);
      _addTaskToStatusList(updatedTask);
    }
  }

  void _updateTaskInPlace(TaskListModel updatedTask) {
    final taskList = _getTaskListByStatus(updatedTask.status);
    int index = taskList.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) taskList[index] = updatedTask;
  }

  void _addTaskToStatusList(TaskListModel task) {
    _getTaskListByStatus(task.status).insert(0, task);
  }

  void _removeTaskFromAllLists(int taskId) {
    todoTasks.removeWhere((task) => task.id == taskId);
    inProgressTasks.removeWhere((task) => task.id == taskId);
    completedTasks.removeWhere((task) => task.id == taskId);
    blockedTasks.removeWhere((task) => task.id == taskId);
  }

  TaskListModel? findTaskById(int taskId) {
    for (TaskStatus status in [
      TaskStatus.todo,
      TaskStatus.inProgress,
      TaskStatus.completed,
      TaskStatus.blocked
    ]) {
      final taskList = _getTaskListByStatus(status);
      final foundTask = taskList.firstWhereOrNull((task) => task.id == taskId);
      if (foundTask != null) return foundTask;
    }
    return null;
  }

  void removeTaskFromList(int taskId) {
    TaskListModel? taskToDelete = findTaskById(taskId);
    if (taskToDelete == null) return;

    _removeTaskFromAllLists(taskId);

    _decrementPaginationCount(taskToDelete.status);
  }

  void _decrementPaginationCount(TaskStatus status) {
    final currentPagination = getPagination(status);
    if (currentPagination != null) {
      updatePagination(
          status,
          Pagination(
            page: currentPagination.page,
            totalPages: currentPagination.totalPages,
            total: (currentPagination.total ?? 0) - 1,
          ));
    }
  }
}
