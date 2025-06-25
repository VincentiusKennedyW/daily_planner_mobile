import 'dart:convert';

import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';

class AssignToTaskController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final GetTaskController getTaskController = Get.find<GetTaskController>();
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  Future<bool> assignToTask(int taskId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/$taskId/assign';
      final token = _storage.read('token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final userDataString = _storage.read('user_data');
      final userDataMap = json.decode(userDataString);
      final userModel = UserModel.fromJson(userDataMap);
      final userWithName = UserWithName(
        id: userModel.id!,
        name: userModel.name!,
      );

      _updateTaskAssigneeWithCopyWith(taskId, userWithName, isAssigning: true);

      if (response.statusCode == 200) {
        return true;
      } else {
        _updateTaskAssigneeWithCopyWith(taskId, userWithName,
            isAssigning: false);

        errorMessage.value = 'Failed to assign task';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> unassignFromTask(int taskId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/$taskId/unassign';
      final token = _storage.read('token');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final userDataString = _storage.read('user_data');
      final userDataMap = json.decode(userDataString);
      final userModel = UserModel.fromJson(userDataMap);
      final userWithName = UserWithName(
        id: userModel.id!,
        name: userModel.name!,
      );

      _updateTaskAssigneeWithCopyWith(taskId, userWithName, isAssigning: false);

      if (response.statusCode == 200) {
        return true;
      } else {
        _updateTaskAssigneeWithCopyWith(taskId, userWithName,
            isAssigning: true);

        errorMessage.value = 'Failed to unassign task';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _updateTaskAssigneeWithCopyWith(int taskId, UserWithName user,
      {required bool isAssigning}) {
    final taskIndex =
        getTaskController.todoTasks.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      final currentTask = getTaskController.todoTasks[taskIndex];
      List<UserWithName> updatedAssignees =
          List.from(currentTask.assignees ?? []);

      if (isAssigning) {
        if (!updatedAssignees.any((assignee) => assignee.id == user.id)) {
          updatedAssignees.add(user);
        }
      } else {
        updatedAssignees.removeWhere((assignee) => assignee.id == user.id);
      }

      final updatedTask = currentTask.copyWith(
        assignees: updatedAssignees,
        updatedAt: DateTime.now(),
      );

      getTaskController.todoTasks[taskIndex] = updatedTask;
    }
  }
}
