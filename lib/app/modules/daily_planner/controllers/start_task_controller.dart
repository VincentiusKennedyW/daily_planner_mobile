import 'dart:convert';
import 'dart:developer' as developer;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/responses/start_task_response.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class StartTaskController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final GetTaskController getTaskController = Get.find<GetTaskController>();
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  Future<void> startTask(int taskId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/$taskId/start';
      final token = _storage.read('token');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData =
            StartTaskResponse.fromJson(json.decode(response.body));
        if (responseData.status == 'success') {
          final taskIndex = getTaskController.todoTasks
              .indexWhere((task) => task.id == taskId);

          final task = getTaskController.todoTasks.removeAt(taskIndex);
          task.status = TaskStatus.inProgress;
          getTaskController.inProgressTasks.insert(0, task);

          var inProgressPagination =
              getTaskController.inProgressPagination.value;
          var todoPagination = getTaskController.todoPagination.value;

          if (inProgressPagination != null) {
            getTaskController.todoPagination.value = Pagination(
              page: todoPagination?.page,
              totalPages: todoPagination?.totalPages,
              total: (todoPagination?.total ?? 0) - 1,
            );

            getTaskController.inProgressPagination.value = Pagination(
              page: inProgressPagination.page,
              totalPages: inProgressPagination.totalPages,
              total: (inProgressPagination.total ?? 0) + 1,
            );
          }

          Get.snackbar('Success', responseData.message,
              snackPosition: SnackPosition.BOTTOM);
        } else {
          throw Exception(responseData.message);
        }
      } else {
        throw Exception('Failed to start task: ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
