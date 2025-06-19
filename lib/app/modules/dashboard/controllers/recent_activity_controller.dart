import 'package:expense_tracker/app/data/models/responses/task_response.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/core/config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RecentActivityController extends GetxController {
  final RxList<TaskListModel> recentActivities = <TaskListModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  @override
  void onInit() {
    super.onInit();
    getRecentActivity();
  }

  Future<void> getRecentActivity() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/tasks';
      final token = _storage.read('token');

      final response = await GetConnect().get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final recentActivityResponse =
            GetAllTasksResponse.fromJson(response.body);

        if (recentActivityResponse.status == 'success') {
          recentActivities.value = recentActivityResponse.data?.tasks ?? [];
        } else {
          errorMessage.value = recentActivityResponse.message;
        }
      } else {
        errorMessage.value = 'Error: ${response.statusText}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load recent activities: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
