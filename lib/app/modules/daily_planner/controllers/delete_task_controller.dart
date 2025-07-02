import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/config.dart';

class DeleteTaskController extends GetxController {
  final RxBool isLoadingDelete = false.obs;
  final RxString errorMessageDelete = ''.obs;

  GetTaskController get getTaskController => Get.find<GetTaskController>();
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  Future<bool> deleteTask(int taskId) async {
    try {
      isLoadingDelete.value = true;
      errorMessageDelete.value = '';

      final url = '$baseUrl/task/$taskId';
      final token = _storage.read('token');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        getTaskController.removeTaskFromList(taskId);
        return true;
      } else {
        try {
          final responseData = json.decode(response.body);
          errorMessageDelete.value =
              'Gagal menghapus task: ${responseData['message'] ?? 'Unknown error'}';
        } catch (_) {
          errorMessageDelete.value = 'HTTP Error: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      errorMessageDelete.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoadingDelete.value = false;
    }
  }
}
