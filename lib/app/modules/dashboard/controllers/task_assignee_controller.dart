import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/responses/task_assignee_response.dart';
import 'package:expense_tracker/core/config.dart';

class TaskAssigneeController extends GetxController {
  final Rxn<TaskAssigneeResponse> totalTaskStatistics = Rxn<TaskAssigneeResponse>();
  final Rxn<TaskAssigneeResponse> monthlyTaskStatistics = Rxn<TaskAssigneeResponse>();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMonthly = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorMessageMonthly = ''.obs;
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  @override
  void onInit() {
    super.onInit();
    getMonthlyTaskStatistics();
    getTotalTaskStatistics();
  }

  Future<void> getTotalTaskStatistics() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final url = '$baseUrl/tasks/statistics';
      final token = _storage.read('token');

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final taskStatisticsResponse =
            TaskAssigneeResponse.fromJson(json.decode(response.body));

        if (taskStatisticsResponse.status == 'success') {
          totalTaskStatistics.value = taskStatisticsResponse;
        } else {
          errorMessage.value = taskStatisticsResponse.message;
        }
      } else {
        errorMessage.value = 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load total task statistics: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMonthlyTaskStatistics() async {
    try {
      isLoadingMonthly.value = true;
      errorMessageMonthly.value = '';

      final userData = _storage.read('user_data');

      int? userId;
      if (userData != null) {
        try {
          final userMap = userData is String ? json.decode(userData) : userData;
          userId = userMap['id'];
        } catch (e) {
          developer.log(
            'Error parsing user_data: $e',
            name: 'TaskAssigneeController',
          );
        }
      }

      final url = '$baseUrl/user/performance/$userId';
      final token = _storage.read('token');

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final taskMonthlyResponse =
            TaskAssigneeResponse.fromJson(json.decode(response.body));

        if (taskMonthlyResponse.status == 'success') {
          monthlyTaskStatistics.value = taskMonthlyResponse;
        } else {
          errorMessageMonthly.value = taskMonthlyResponse.message;
        }
      } else {
        errorMessageMonthly.value = 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessageMonthly.value = 'Failed to load monthly task statistics: $e';
    } finally {
      isLoadingMonthly.value = false;
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      getTotalTaskStatistics(),
      getMonthlyTaskStatistics(),
    ]);
  }
}
