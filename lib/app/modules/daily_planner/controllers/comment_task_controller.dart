import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/task_models/comment_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:expense_tracker/core/task.dart';

class CommentTaskController extends GetxController {
  final Rxn<TaskListModel> currentTask = Rxn<TaskListModel>();
  final RxBool isLoadingComment = false.obs;
  final RxString errorMessage = ''.obs;
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  final GetTaskController _getTaskController = Get.find<GetTaskController>();

  void setCurrentTask(TaskListModel task) {
    currentTask.value = task;
  }

  Future<bool> addComment(String comment) async {
    try {
      if (currentTask.value == null) {
        errorMessage.value = 'Tidak ada tugas yang dipilih.';
        return false;
      }

      isLoadingComment.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/${currentTask.value!.id}/comments';
      final token = _storage.read('token');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': comment}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        final newComment =
            Comment.fromJson(responseData['data']['comments'][0]);

        final updatedComments = List<Comment>.from(
          currentTask.value!.comments ?? [],
        )..insert(0, newComment);

        final updatedTask = currentTask.value!.copyWith(
          comments: updatedComments,
        );

        currentTask.value = updatedTask;

        _updateTaskInGlobalState(updatedTask);
        return true;
      } else {
        errorMessage.value =
            'Gagal menambahkan komentar: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<bool> deleteComment(int commentId) async {
    try {
      if (currentTask.value == null) {
        errorMessage.value = 'Tidak ada tugas yang dipilih.';
        return false;
      }

      isLoadingComment.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/task/comments/$commentId';
      final token = _storage.read('token');
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final updatedComments = List<Comment>.from(
          currentTask.value!.comments ?? [],
        )..removeWhere((comment) => comment.id == commentId);

        final updatedTask = currentTask.value!.copyWith(
          comments: updatedComments,
        );

        currentTask.value = updatedTask;

        _updateTaskInGlobalState(updatedTask);
        return true;
      } else {
        final responseData = json.decode(response.body);
        errorMessage.value =
            'Gagal menghapus komentar: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoadingComment.value = false;
    }
  }

  void _updateTaskInGlobalState(TaskListModel updatedTask) {
    switch (updatedTask.status) {
      case TaskStatus.todo:
        final index = _getTaskController.todoTasks
            .indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _getTaskController.todoTasks[index] = updatedTask;
        }
        break;
      case TaskStatus.inProgress:
        final index = _getTaskController.inProgressTasks
            .indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _getTaskController.inProgressTasks[index] = updatedTask;
        }
        break;
      case TaskStatus.completed:
        final index = _getTaskController.completedTasks
            .indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _getTaskController.completedTasks[index] = updatedTask;
        }
        break;
      case TaskStatus.blocked:
        final index = _getTaskController.blockedTasks
            .indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _getTaskController.blockedTasks[index] = updatedTask;
        }
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
}
