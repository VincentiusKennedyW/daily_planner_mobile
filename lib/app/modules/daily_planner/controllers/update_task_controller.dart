import 'dart:convert';

import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UpdateTaskController extends GetxController {
  final RxBool isLoadingUpdate = false.obs;
  final RxString errorMessageUpdate = ''.obs;
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  CommentTaskController get _commentTaskController =>
      Get.find<CommentTaskController>();

  GetTaskController get _getTaskController => Get.find<GetTaskController>();

  Future<bool> updateTask(int taskId, CreateTaskModel taskData) async {
    try {
      isLoadingUpdate.value = true;
      errorMessageUpdate.value = '';

      final url = '$baseUrl/task/$taskId';
      final token = _storage.read('token');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(taskData),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedTask = TaskListModel.fromJson(responseData['data']);

        _commentTaskController.currentTask.value = updatedTask;

        _getTaskController.updateTaskInList(updatedTask);

        return true;
      } else {
        errorMessageUpdate.value =
            'Gagal mengupdate task: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessageUpdate.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoadingUpdate.value = false;
    }
  }
}
