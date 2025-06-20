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
      getTasksByStatus(TaskStatus.blocked),
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
    switch (status) {
      case TaskStatus.todo:
        todoTasks.assignAll(tasks);
        break;
      case TaskStatus.inProgress:
        inProgressTasks.assignAll(tasks);
        break;
      case TaskStatus.completed:
        completedTasks.assignAll(tasks);
        break;
      case TaskStatus.blocked:
        blockedTasks.assignAll(tasks);
        break;
      default:
        break;
    }
  }

  void _appendTasksByStatus(TaskStatus status, List<TaskListModel> newTasks) {
    switch (status) {
      case TaskStatus.todo:
        todoTasks.addAll(newTasks);
        break;
      case TaskStatus.inProgress:
        inProgressTasks.addAll(newTasks);
        break;
      case TaskStatus.completed:
        completedTasks.addAll(newTasks);
        break;
      case TaskStatus.blocked:
        blockedTasks.addAll(newTasks);
        break;
      default:
        break;
    }
  }

  Future<void> refreshTab(TaskStatus status) async {
    await getTasksByStatus(status);
  }
}
