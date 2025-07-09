import 'package:get/get.dart';
import 'package:expense_tracker/core/base_http_service.dart';
import 'package:expense_tracker/app/data/models/project_models/project_model.dart';

class AssignTasksToProjectController extends BaseService {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<ProjectModel?> assignTasksToProject(
      int projectId, List<int> taskIds) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await post('/project/$projectId/assign-tasks', {
        'taskIds': taskIds,
      });

      if (response.statusCode == 200) {
        if (response.body != null && response.body['data'] != null) {
          return ProjectModel.fromJson(response.body['data']);
        }
        return null;
      } else {
        errorMessage.value =
            response.body['message'] ?? 'Failed to assign tasks to project';
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
