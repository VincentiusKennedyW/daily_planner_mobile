import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';

import '../widgets/empty_projects_view.dart';
import 'widgets/project_card.dart';
import '../widgets/project_error_view.dart';
import 'widgets/project_list_bottom_loader.dart';

class ProjectListView extends StatelessWidget {
  final ScrollController scrollController;
  final GetProjectController controller;

  const ProjectListView({
    super.key,
    required this.scrollController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.projects.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return ProjectOrTaskErrorView(
          isTaskError: false,
          errorMessage: controller.errorMessage.value,
          onRetry: () => controller.refreshProjects(),
        );
      }

      if (controller.projects.isEmpty) {
        return EmptyTaskOrProjectView(
          isTaskView: false,
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshProjects(),
        color: Color(0xFF6366F1),
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.projects.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.projects.length) {
              return ProjectCard(project: controller.projects[index]);
            } else {
              return buildProjectBottomLoader(controller.isPaginationLoading.value);
            }
          },
        ),
      );
    });
  }
}
