import 'dart:developer' as developer;
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/app/data/models/responses/project_response.dart';
import 'package:expense_tracker/core/base_http_service.dart';

class GetProjectController extends GetxController {
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Pagination?> pagination = Rx<Pagination?>(null);

  final BaseService _apiService = Get.find<BaseService>();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects({
    int page = 1,
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        isPaginationLoading.value = true;
      } else {
        isLoading.value = true;
        errorMessage.value = '';
      }

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/projects',
        query: queryParams,
      );

      final projectResponse = _apiService.handleResponse<GetAllProjectResponse>(
        response,
        (json) => GetAllProjectResponse.fromJson(json),
      );

      if (projectResponse != null && projectResponse.status == 'success') {
        if (isLoadMore) {
          projects.addAll(projectResponse.data?.projects ?? []);
        } else {
          projects.assignAll(projectResponse.data?.projects ?? []);
        }

        developer.log(
          'Loaded projects: ${projects.length}',
          name: 'GetProjectController.loadProjects',
        );

        pagination.value = projectResponse.data?.pagination;
      } else {
        errorMessage.value =
            projectResponse?.message ?? 'Failed to load projects';
      }
    } catch (e) {
      developer.log(
        'Error loading projects: $e',
        name: 'GetProjectController.loadProjects',
        error: e,
        stackTrace: StackTrace.current,
      );
      errorMessage.value = 'Failed to load projects: $e';
    } finally {
      if (isLoadMore) {
        isPaginationLoading.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMoreProjects() async {
    if (!hasNextPage || isPaginationLoading.value) return;

    final nextPage = (pagination.value?.page ?? 0) + 1;
    await loadProjects(page: nextPage, isLoadMore: true);
  }

  Future<void> refreshProjects() async {
    await loadProjects();
  }

  bool get hasNextPage {
    final pag = pagination.value;
    if (pag == null) return false;
    return (pag.page ?? 0) < (pag.totalPages ?? 0);
  }

  ProjectModel? getProjectById(int projectId) {
    return projects.firstWhereOrNull((project) => project.id == projectId);
  }
}
