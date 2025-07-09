import 'dart:convert';

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/start_task_response.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CompleteTaskController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final GetTaskController getTaskController = Get.find<GetTaskController>();
  final TaskAssigneeController taskAssigneeController =
      Get.find<TaskAssigneeController>();
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  Future<bool> completeTask(int taskId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/$taskId/complete';
      final token = _storage.read('token');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData =
          TaskProgressResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (responseData.status == 'success') {
          final taskIndex = getTaskController.inProgressTasks
              .indexWhere((task) => task.id == taskId);

          final task = getTaskController.inProgressTasks.removeAt(taskIndex);
          task.status = TaskStatus.completed;
          getTaskController.completedTasks.insert(0, task);

          var completedPagination = getTaskController.completedPagination.value;
          var inProgressPagination =
              getTaskController.inProgressPagination.value;

          if (completedPagination != null) {
            getTaskController.inProgressPagination.value = Pagination(
              page: inProgressPagination?.page,
              totalPages: inProgressPagination?.totalPages,
              total: (inProgressPagination?.total ?? 0) - 1,
            );

            getTaskController.completedPagination.value = Pagination(
              page: completedPagination.page,
              totalPages: completedPagination.totalPages,
              total: (completedPagination.total ?? 0) + 1,
            );
          }

          if (taskAssigneeController.monthlyTaskStatistics.value != null) {
            taskAssigneeController.monthlyTaskStatistics.value =
                taskAssigneeController.monthlyTaskStatistics.value!.copyWith(
              data: taskAssigneeController.monthlyTaskStatistics.value!.data
                  .copyWith(
                inProgress: taskAssigneeController
                        .monthlyTaskStatistics.value!.data.inProgress -
                    1,
                completed: taskAssigneeController
                        .monthlyTaskStatistics.value!.data.completed +
                    1,
                totalPoints: taskAssigneeController
                        .monthlyTaskStatistics.value!.data.totalPoints +
                    responseData.data.pointsEarned,
              ),
            );
          }

          if (taskAssigneeController.totalTaskStatistics.value != null) {
            taskAssigneeController.totalTaskStatistics.value =
                taskAssigneeController.totalTaskStatistics.value!.copyWith(
              data: taskAssigneeController.totalTaskStatistics.value!.data
                  .copyWith(
                inProgress: taskAssigneeController
                        .totalTaskStatistics.value!.data.inProgress -
                    1,
                completed: taskAssigneeController
                        .totalTaskStatistics.value!.data.completed +
                    1,
                totalPoints: taskAssigneeController
                        .totalTaskStatistics.value!.data.totalPoints +
                    responseData.data.pointsEarned,
              ),
            );
          }

          return true;
        } else {
          errorMessage.value = responseData.message;
          return false;
        }
      } else {
        errorMessage.value = responseData.message;
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
