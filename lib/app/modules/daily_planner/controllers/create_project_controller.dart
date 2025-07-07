import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/project_models/create_project_model.dart';
import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/app/data/models/responses/create_project_response.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';
import 'package:expense_tracker/core/config.dart';

class CreateProjectController extends GetxController {
  final RxBool isLoadingCreate = false.obs;
  final RxString errorMessageCreate = ''.obs;
  final Rxn<ProjectModel> createdProject = Rxn<ProjectModel>();

  final GetProjectController getProjectController =
      Get.find<GetProjectController>();
  final String baseUrl = Config.url;
  final GetStorage _storage = GetStorage();

  Future<bool> createProject(CreateProjectModel createProject) async {
    try {
      isLoadingCreate.value = true;
      errorMessageCreate.value = '';

      final url = '$baseUrl/project';
      final token = _storage.read('token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(createProject.toJson()),
      );

      if (response.statusCode == 201) {
        final projectResponse =
            CreateProjectResponse.fromJson(json.decode(response.body));
        if (projectResponse.status == 'success') {
          createdProject.value = projectResponse.data;
          getProjectController.projects.insert(
              0,
              ProjectModel(
                id: projectResponse.data.id,
                name: projectResponse.data.name,
                projectNo: projectResponse.data.projectNo,
                startDate: projectResponse.data.startDate,
                endDate: projectResponse.data.endDate,
                createdAt: projectResponse.data.createdAt,
                updatedAt: projectResponse.data.updatedAt,
                tasks: projectResponse.data.tasks,
              ));

          var projectPagination = getProjectController.pagination.value;
          if (projectPagination != null) {
            getProjectController.pagination.value = Pagination(
              page: projectPagination.page,
              limit: projectPagination.limit,
              total: (projectPagination.total ?? 0) + 1,
            );
          }
          return true;
        } else {
          errorMessageCreate.value = projectResponse.message;
          return false;
        }
      } else {
        final errorData = json.decode(response.body);
        errorMessageCreate.value =
            'Gagal membuat proyek: ${errorData['message'] ?? 'Unknown error'}';
        return false;
      }
    } catch (e) {
      errorMessageCreate.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoadingCreate.value = false;
    }
  }
}
