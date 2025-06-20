import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/create_task_response.dart';
import 'package:expense_tracker/app/data/models/responses/task_response.dart';
import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  final RxList<TaskListModel> todoTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> inProgressTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> completedTasks = <TaskListModel>[].obs;
  final RxList<TaskListModel> blockedTasks = <TaskListModel>[].obs;

  final Rxn<Pagination> todoPagination = Rxn<Pagination>();
  final Rxn<Pagination> inProgressPagination = Rxn<Pagination>();
  final Rxn<Pagination> completedPagination = Rxn<Pagination>();
  final Rxn<Pagination> blockedPagination = Rxn<Pagination>();

  final RxBool isTodoLoading = false.obs;
  final RxBool isInProgressLoading = false.obs;
  final RxBool isCompletedLoading = false.obs;
  final RxBool isBlockedLoading = false.obs;

  final RxBool isTodoPaginationLoading = false.obs;
  final RxBool isInProgressPaginationLoading = false.obs;
  final RxBool isCompletedPaginationLoading = false.obs;
  final RxBool isBlockedPaginationLoading = false.obs;

  final RxBool isLoadingCreate = false.obs;

  final RxString todoError = ''.obs;
  final RxString inProgressError = ''.obs;
  final RxString completedError = ''.obs;
  final RxString blockedError = ''.obs;
  final RxString errorMessageCreate = ''.obs;

  final Rxn<CreatedTaskModel> createdTask = Rxn<CreatedTaskModel>();
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
        _setLoadingMoreState(status, true);
      } else {
        _setLoadingState(status, true);
        _setErrorMessage(status, '');
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
          _updatePaginationByStatus(
              status, taskResponse.data?.pagination ?? Pagination());
        } else {
          _setErrorMessage(status, taskResponse.message);
        }
      } else {
        _setErrorMessage(status, 'HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      _setErrorMessage(status, 'Failed to load tasks: $e');
    } finally {
      if (isLoadMore) {
        _setLoadingMoreState(status, false);
      } else {
        _setLoadingState(status, false);
      }
    }
  }

  Future<void> loadMoreTaskByStatus(TaskStatus status) async {
    final pagination = _getPaginationByStatus(status);
    if (pagination == null || !_hasNextPage(pagination)) return;

    final nextPage = (pagination.page ?? 0) + 1;
    await getTasksByStatus(status, page: nextPage, isLoadMore: true);
  }

  // Method untuk refresh tab tertentu
  Future<void> refreshTab(TaskStatus status) async {
    await getTasksByStatus(status);
  }

  // Method untuk refresh semua tab
  Future<void> refreshAllTabs() async {
    await loadAllTabs();
  }

  Future<bool> createTask(CreateTaskModel createTaskModel) async {
    try {
      isLoadingCreate.value = true;
      errorMessageCreate.value = '';

      final url = '$baseUrl/task';
      final token = _storage.read('token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createTaskModel.toJson()),
      );

      if (response.statusCode == 201) {
        final taskResponse =
            CreateTaskResponse.fromJson(json.decode(response.body));

        if (taskResponse.status == 'success') {
          createdTask.value = taskResponse.data;
          switch (taskResponse.data.status) {
            case TaskStatus.todo:
              todoTasks.insert(
                  0,
                  TaskListModel(
                    id: taskResponse.data.id,
                    title: taskResponse.data.title,
                    description: taskResponse.data.description,
                    category: taskResponse.data.category,
                    point: taskResponse.data.point,
                    priority: taskResponse.data.priority,
                    assignees: taskResponse.data.assignees,
                    dueDate: taskResponse.data.dueDate,
                    tags: taskResponse.data.tags,
                    estimatedHours: taskResponse.data.estimatedHours,
                    status: TaskStatus.todo,
                    createdAt: taskResponse.data.createdAt,
                    updatedAt: DateTime.now(),
                    creator: taskResponse.data.creator,
                  ));

              break;
            default:
              break;
          }
          return true;
        } else {
          errorMessageCreate.value = taskResponse.message;

          return false;
        }
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      errorMessageCreate.value = 'Failed to create task: $e';
      return false;
    } finally {
      isLoadingCreate.value = false;
    }
  }

// Helper method untuk handle error response
  bool _handleErrorResponse(http.Response response) {
    try {
      // Coba parse response body sebagai JSON
      final Map<String, dynamic> errorData = json.decode(response.body);

      // Cek berbagai format error message yang mungkin
      String errorMessage = 'HTTP Error: ${response.statusCode}';

      if (errorData.containsKey('message')) {
        errorMessage = errorData['message'];
      } else if (errorData.containsKey('error')) {
        errorMessage = errorData['error'];
      } else if (errorData.containsKey('msg')) {
        errorMessage = errorData['msg'];
      } else if (errorData.containsKey('detail')) {
        errorMessage = errorData['detail'];
      } else if (errorData.containsKey('errors')) {
        // Handle validation errors (Laravel style)
        final errors = errorData['errors'];
        if (errors is Map) {
          final List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.cast<String>());
            } else {
              errorMessages.add(value.toString());
            }
          });
          errorMessage = errorMessages.join(', ');
        } else if (errors is List) {
          errorMessage = errors.join(', ');
        }
      }

      errorMessageCreate.value = errorMessage;

      developer.log(
        'HTTP Error ${response.statusCode}: $errorMessage',
        name: 'TaskController',
      );

      return false;
    } catch (parseException) {
      // Jika response body tidak bisa di-parse sebagai JSON
      errorMessageCreate.value = 'HTTP Error: ${response.statusCode}';

      developer.log(
        'Failed to parse error response: ${response.statusCode} - ${response.body}',
        name: 'TaskController',
      );

      return false;
    }
  }

// // Alternative method dengan try-catch yang lebih spesifik
//   Future<bool> createTaskWithDetailedErrorHandling(
//       CreateTaskModel createTaskModel) async {
//     try {
//       isLoadingCreate.value = true;
//       errorMessageCreate.value = '';

//       final url = '$baseUrl/task';
//       final token = _storage.read('token');

//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(createTaskModel.toJson()),
//       );

//       if (response.statusCode == 201) {
//         final taskResponse =
//             CreateTaskResponse.fromJson(json.decode(response.body));

//         if (taskResponse.status == 'success') {
//           createdTask.value = taskResponse.data;
//           await getTasks();
//           return true;
//         } else {
//           errorMessageCreate.value = taskResponse.message;
//           return false;
//         }
//       } else {
//         return _handleErrorResponse(response);
//       }
//     } on http.ClientException catch (e) {
//       // Network connection error
//       errorMessageCreate.value = 'Network error: Please check your connection';
//       developer.log('Network error: $e', name: 'TaskController');
//       return false;
//     } on FormatException catch (e) {
//       // JSON parsing error
//       errorMessageCreate.value = 'Invalid response format';
//       developer.log('JSON parsing error: $e', name: 'TaskController');
//       return false;
//     } on TimeoutException catch (e) {
//       // Request timeout
//       errorMessageCreate.value = 'Request timeout. Please try again';
//       developer.log('Timeout error: $e', name: 'TaskController');
//       return false;
//     } catch (e) {
//       // Other unexpected errors
//       errorMessageCreate.value = 'An unexpected error occurred';
//       developer.log('Unexpected error: $e', name: 'TaskController');
//       return false;
//     } finally {
//       isLoadingCreate.value = false;
//     }
//   }

  void _setLoadingState(TaskStatus status, bool loading) {
    switch (status) {
      case TaskStatus.todo:
        isTodoLoading.value = loading;
        break;
      case TaskStatus.inProgress:
        isInProgressLoading.value = loading;
        break;
      case TaskStatus.completed:
        isCompletedLoading.value = loading;
        break;
      case TaskStatus.blocked:
        isBlockedLoading.value = loading;
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
  }

  void _setLoadingMoreState(TaskStatus status, bool loading) {
    switch (status) {
      case TaskStatus.todo:
        isTodoPaginationLoading.value = loading;
        break;
      case TaskStatus.inProgress:
        isInProgressPaginationLoading.value = loading;
        break;
      case TaskStatus.completed:
        isCompletedPaginationLoading.value = loading;
        break;
      case TaskStatus.blocked:
        isBlockedPaginationLoading.value = loading;
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
  }

  void _setErrorMessage(TaskStatus status, String message) {
    switch (status) {
      case TaskStatus.todo:
        todoError.value = message;
        break;
      case TaskStatus.inProgress:
        inProgressError.value = message;
        break;
      case TaskStatus.completed:
        completedError.value = message;
        break;
      case TaskStatus.blocked:
        blockedError.value = message;
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
      case TaskStatus.cancelled:
        throw UnimplementedError();
      case TaskStatus.overdue:
        throw UnimplementedError();
      case TaskStatus.onReview:
        throw UnimplementedError();
      case TaskStatus.onHold:
        throw UnimplementedError();
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
      case TaskStatus.cancelled:
        throw UnimplementedError();
      case TaskStatus.overdue:
        throw UnimplementedError();
      case TaskStatus.onReview:
        throw UnimplementedError();
      case TaskStatus.onHold:
        throw UnimplementedError();
    }
  }

  void _updatePaginationByStatus(TaskStatus status, Pagination pagination) {
    switch (status) {
      case TaskStatus.todo:
        todoPagination.value = pagination;
        break;
      case TaskStatus.inProgress:
        inProgressPagination.value = pagination;
        break;
      case TaskStatus.completed:
        completedPagination.value = pagination;
        break;
      case TaskStatus.blocked:
        blockedPagination.value = pagination;
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
  }

  Pagination? _getPaginationByStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return todoPagination.value;
      case TaskStatus.inProgress:
        return inProgressPagination.value;
      case TaskStatus.completed:
        return completedPagination.value;
      case TaskStatus.blocked:
        return blockedPagination.value;
      case TaskStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.overdue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.onReview:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.onHold:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  bool _getLoadingMoreState(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return isTodoPaginationLoading.value;
      case TaskStatus.inProgress:
        return isInProgressLoading.value;
      case TaskStatus.completed:
        return isCompletedLoading.value;
      case TaskStatus.blocked:
        return isBlockedLoading.value;
      case TaskStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.overdue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.onReview:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.onHold:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  bool _hasNextPage(Pagination pagination) {
    return (pagination.page ?? 0) < (pagination.totalPages ?? 0);
  }

  // Getter untuk mengecek apakah masih bisa load more
  bool canLoadMoreTodo() {
    final pagination = todoPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isTodoPaginationLoading.value;
  }

  bool canLoadMoreInProgress() {
    final pagination = inProgressPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isInProgressPaginationLoading.value;
  }

  bool canLoadMoreCompleted() {
    final pagination = completedPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isCompletedPaginationLoading.value;
  }

  bool canLoadMoreBlocked() {
    final pagination = blockedPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isBlockedPaginationLoading.value;
  }

// Helper method untuk handle common HTTP status codes
  String _getStatusCodeMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input';
      case 401:
        return 'Unauthorized. Please login again';
      case 403:
        return 'Forbidden. You don\'t have permission';
      case 404:
        return 'Not found. Please check the URL';
      case 422:
        return 'Validation failed. Please check your input';
      case 429:
        return 'Too many requests. Please try again later';
      case 500:
        return 'Server error. Please try again later';
      case 502:
        return 'Bad gateway. Server is temporarily unavailable';
      case 503:
        return 'Service unavailable. Please try again later';
      default:
        return 'HTTP Error: $statusCode';
    }
  }
  // Future<bool> createTaskWithParams({
  //   required String title,
  //   required String description,
  //   required TaskCategory category,
  //   required int point,
  //   required TaskPriority priority,
  //   List<int>? assigneeIds,
  //   DateTime? dueDate,
  //   List<String>? tags,
  //   int? estimatedHours,
  // }) async {
  //   final createTaskModel = CreateTaskModel(
  //     title: title,
  //     description: description,
  //     category: category,
  //     point: point,
  //     priority: priority,
  //     assigneeIds: assigneeIds,
  //     dueDate: dueDate,
  //     tags: tags,
  //     estimatedHours: estimatedHours,
  //   );

  //   return await createTask(createTaskModel);
  // }

  // // Helper method untuk mendapatkan task berdasarkan ID
  // TaskListModel? getTaskById(int id) {
  //   try {
  //     return tasks.firstWhere((task) => task.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // // Helper method untuk filter tasks berdasarkan status
  // List<TaskListModel> getTasksByStatus(TaskStatus status) {
  //   return tasks.where((task) => task.status == status).toList();
  // }

  // // Helper method untuk filter tasks berdasarkan priority
  // List<TaskListModel> getTasksByPriority(TaskPriority priority) {
  //   return tasks.where((task) => task.priority == priority).toList();
  // }

  // // Helper method untuk filter tasks berdasarkan category
  // List<TaskListModel> getTasksByCategory(TaskCategory category) {
  //   return tasks.where((task) => task.category == category).toList();
  // }

  // // Helper method untuk mendapatkan tasks yang assigned ke user tertentu
  // List<TaskListModel> getTasksByAssignee(int userId) {
  //   return tasks
  //       .where((task) =>
  //           task.assignees?.any((assignee) => assignee.id == userId) ?? false)
  //       .toList();
  // }

  // // Helper method untuk refresh tasks
  // Future<void> refreshTasks() async {
  //   await getTasks();
  // }

  // // Helper method untuk load more tasks (pagination)
  // Future<void> loadMoreTasks() async {
  //   if (pagination.value != null) {
  //     final currentPage = pagination.value!.page;
  //     final totalPages = pagination.value!.totalPages;

  //     if (currentPage < totalPages) {
  //       await getTasks(page: currentPage + 1);
  //     }
  //   }
  // }

  // // Helper method untuk clear errors
  // void clearErrors() {
  //   errorMessage.value = '';
  //   errorMessageCreate.value = '';
  // }

  // // Helper method untuk check if can load more
  // bool get canLoadMore {
  //   if (pagination.value == null) return false;
  //   return pagination.value!.page < pagination.value!.totalPages;
  // }

  // // Helper method untuk get total tasks count
  // int get totalTasks {
  //   return pagination.value?.total ?? 0;
  // }
}
