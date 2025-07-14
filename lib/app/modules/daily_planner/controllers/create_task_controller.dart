import 'dart:convert';

import 'package:expense_tracker/app/modules/dashboard/controllers/leaderboard_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';
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
  final LeaderboardController leaderboardController =
      Get.find<LeaderboardController>();
  final TaskAssigneeController taskAssigneeController =
      Get.find<TaskAssigneeController>();

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

          if (taskAssigneeController.monthlyTaskStatistics.value != null) {
            var currentStats =
                taskAssigneeController.monthlyTaskStatistics.value!;
            taskAssigneeController.monthlyTaskStatistics.value =
                currentStats.copyWith(
              data: currentStats.data.copyWith(
                todo: currentStats.data.todo + 1,
                total: currentStats.data.total + 1,
              ),
            );
          }

          if (taskAssigneeController.totalTaskStatistics.value != null) {
            var currentStats =
                taskAssigneeController.totalTaskStatistics.value!;
            taskAssigneeController.totalTaskStatistics.value =
                currentStats.copyWith(
              data: currentStats.data.copyWith(
                todo: currentStats.data.todo + 1,
                total: currentStats.data.total + 1,
              ),
            );
          }

          return true;
        } else {
          errorMessageCreate.value = taskResponse.message;
          return false;
        }
      } else {
        final errorData = json.decode(response.body);
        errorMessageCreate.value =
            'Failed to create task: ${errorData['message'] ?? 'Unknown error'}';
        return false;
      }
    } catch (e) {
      errorMessageCreate.value = 'Failed to create task: $e';
      return false;
    } finally {
      isLoadingCreate.value = false;
    }
  }
}
