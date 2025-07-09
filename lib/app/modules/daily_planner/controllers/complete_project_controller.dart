import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/project_detail_controller.dart';
import 'package:expense_tracker/core/config.dart';

class CompleteProjectController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // final GetProjectController getProjectController =
  //     Get.find<GetProjectController>();

  GetProjectController getProjectController = Get.find<GetProjectController>();

  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;

  Future<bool> setProjectStartDate(int projectId, DateTime startDate) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/project/$projectId';
      final token = _storage.read('token');

      final formattedDate = DateTime.utc(
              startDate.year, startDate.month, startDate.day)
          .toIso8601String();

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'startDate': formattedDate,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedProject = ProjectModel.fromJson(responseData['data']);

        final projectIndex = getProjectController.projects
            .indexWhere((project) => project.id == projectId);
        if (projectIndex != -1) {
          getProjectController.projects[projectIndex] = updatedProject;
          getProjectController.projects.refresh();
        }

        // Update project detail controller if it exists
        try {
          final projectDetailController = Get.find<ProjectDetailController>();
          projectDetailController.updateProject(updatedProject);
        } catch (e) {
          // Project detail controller not found, ignore
        }

        return true;
      } else {
        errorMessage.value =
            'Gagal mengatur tanggal mulai: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setProjectEndDate(int projectId, DateTime endDate) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/project/$projectId';
      final token = _storage.read('token');

      final formattedDate = DateTime.utc(
              endDate.year, endDate.month, endDate.day, endDate.hour, endDate.minute, endDate.second)
          .toIso8601String();

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'endDate': formattedDate,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedProject = ProjectModel.fromJson(responseData['data']);

        final projectIndex = getProjectController.projects
            .indexWhere((project) => project.id == projectId);
        if (projectIndex != -1) {
          getProjectController.projects[projectIndex] = updatedProject;
          getProjectController.projects.refresh();
        }

        // Update project detail controller if it exists
        try {
          final projectDetailController = Get.find<ProjectDetailController>();
          projectDetailController.updateProject(updatedProject);
        } catch (e) {
          // Project detail controller not found, ignore
        }

        return true;
      } else {
        errorMessage.value =
            'Gagal mengatur tanggal selesai: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeProject(int projectId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = '$baseUrl/project/$projectId';
      final token = _storage.read('token');

      final now = DateTime.now();
      final formattedDate = DateTime.utc(
              now.year, now.month, now.day, now.hour, now.minute, now.second)
          .toIso8601String();

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'endDate': formattedDate,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedProject = ProjectModel.fromJson(responseData['data']);

        final projectIndex = getProjectController.projects
            .indexWhere((project) => project.id == projectId);
        if (projectIndex != -1) {
          getProjectController.projects[projectIndex] = updatedProject;
          getProjectController.projects.refresh();
        }

        // Update project detail controller if it exists
        try {
          final projectDetailController = Get.find<ProjectDetailController>();
          projectDetailController.updateProject(updatedProject);
        } catch (e) {
          // Project detail controller not found, ignore
        }

        return true;
      } else {
        errorMessage.value =
            'Gagal menyelesaikan project: ${responseData['message']}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
