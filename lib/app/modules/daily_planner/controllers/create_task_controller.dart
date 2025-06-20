import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/create_task_response.dart';
import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/task.dart';

class CreateTaskController extends GetxController {
  final RxBool isLoadingCreate = false.obs;
  final RxString errorMessageCreate = ''.obs;
  final Rxn<CreatedTaskModel> createdTask = Rxn<CreatedTaskModel>();

  final GetTaskController getTaskController = Get.find<GetTaskController>();
  final String baseUrl = Config.url;
  final GetStorage _storage = GetStorage();

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
              getTaskController.todoTasks.insert(
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

              var todoPagination = getTaskController.todoPagination.value;
              if (todoPagination != null) {
                getTaskController.todoPagination.value = Pagination(
                  page: todoPagination.page,
                  totalPages: todoPagination.totalPages,
                  total: (todoPagination.total ?? 0) + 1,
                );
              }
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

  bool _handleErrorResponse(http.Response response) {
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
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
      developer.log('HTTP Error ${response.statusCode}: $errorMessage',
          name: 'CreateTaskController');
      return false;
    } catch (_) {
      errorMessageCreate.value = 'HTTP Error: ${response.statusCode}';
      developer.log(
          'Failed to parse error: ${response.statusCode} - ${response.body}',
          name: 'CreateTaskController');
      return false;
    }
  }
}
