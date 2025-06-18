import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/create_task_response.dart';
import 'package:expense_tracker/app/data/models/responses/task_response.dart';
import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  final RxList<TaskListModel> tasks = <TaskListModel>[].obs;
  final Rxn<CreatedTaskModel> createdTask = Rxn<CreatedTaskModel>();
  final Rxn<Pagination> pagination = Rxn<Pagination>();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingCreate = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorMessageCreate = ''.obs;

  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  @override
  void onInit() {
    super.onInit();
    getTasks();
  }

  Future<void> getTasks({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/tasks?page=$page&limit=$limit';
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
          tasks.assignAll(taskResponse.data.tasks);
          pagination.value = taskResponse.data.pagination;
        } else {
          errorMessage.value = taskResponse.message;
        }
      } else {
        errorMessage.value = 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load tasks: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTask(CreateTaskModel createTaskModel) async {
    try {
      isLoadingCreate.value = true;
      errorMessageCreate.value = '';

      final url = '$baseUrl/task';
      final token = _storage.read('token');

      developer.log(
        'Creating task: ${createTaskModel.toJson()}',
        name: 'TaskController',
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createTaskModel.toJson()),
      );

      developer.log(
        'Create task response: ${response.statusCode} - ${response.body}',
        name: 'TaskController',
      );

      // Handle response berdasarkan status code
      if (response.statusCode == 201) {
        // Success response
        final taskResponse =
            CreateTaskResponse.fromJson(json.decode(response.body));

        if (taskResponse.status == 'success') {
          createdTask.value = taskResponse.data;

          developer.log(
            'Task created successfully: ${taskResponse.data.title}',
            name: 'TaskController',
          );

          // Refresh tasks list after creating new task
          await getTasks();
          return true;
        } else {
          // Success status code but response status is not success
          errorMessageCreate.value = taskResponse.message;
          developer.log(
            'Error in response: ${taskResponse.message}',
            name: 'TaskController',
          );
          return false;
        }
      } else {
        // Error status codes (400, 401, 422, 500, etc.)
        return _handleErrorResponse(response);
      }
    } catch (e) {
      // Network error, parsing error, etc.
      errorMessageCreate.value = 'Failed to create task: $e';
      developer.log(
        'Exception creating task: $e',
        name: 'TaskController',
      );
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

// Alternative method dengan try-catch yang lebih spesifik
  Future<bool> createTaskWithDetailedErrorHandling(
      CreateTaskModel createTaskModel) async {
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
          await getTasks();
          return true;
        } else {
          errorMessageCreate.value = taskResponse.message;
          return false;
        }
      } else {
        return _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      // Network connection error
      errorMessageCreate.value = 'Network error: Please check your connection';
      developer.log('Network error: $e', name: 'TaskController');
      return false;
    } on FormatException catch (e) {
      // JSON parsing error
      errorMessageCreate.value = 'Invalid response format';
      developer.log('JSON parsing error: $e', name: 'TaskController');
      return false;
    } on TimeoutException catch (e) {
      // Request timeout
      errorMessageCreate.value = 'Request timeout. Please try again';
      developer.log('Timeout error: $e', name: 'TaskController');
      return false;
    } catch (e) {
      // Other unexpected errors
      errorMessageCreate.value = 'An unexpected error occurred';
      developer.log('Unexpected error: $e', name: 'TaskController');
      return false;
    } finally {
      isLoadingCreate.value = false;
    }
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
