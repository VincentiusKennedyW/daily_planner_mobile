import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';

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
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6366F1),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty &&
          controller.projects.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Error loading projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.refreshProjects(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                ),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.projects.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No projects available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first project to get started',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshProjects(),
        color: Color(0xFF6366F1),
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.all(16),
          itemCount: controller.projects.length +
              (controller.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.projects.length) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              );
            }

            return ProjectCard(project: controller.projects[index]);
          },
        ),
      );
    });
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getProjectStatusColor(project.endDate),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProjectStatusColor(project.endDate)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getProjectStatusText(project.endDate),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getProjectStatusColor(project.endDate),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Project No: ${project.projectNo}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (project.startDate != null || project.endDate != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  if (project.startDate != null) ...[
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Start: ${_formatDate(project.startDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  if (project.startDate != null && project.endDate != null)
                    SizedBox(width: 16),
                  if (project.endDate != null) ...[
                    Icon(
                      Icons.event,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'End: ${_formatDate(project.endDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ],
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  size: 16,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4),
                Text(
                  '${project.tasks?.length ?? 0} Tasks',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4),
                Text(
                  'Created: ${_formatDate(project.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProjectStatusColor(DateTime? endDate) {
    if (endDate == null) return Colors.blue; // Active/Ongoing

    final now = DateTime.now();
    if (endDate.isBefore(now)) {
      return Colors.green; // Completed
    } else {
      return Colors.orange; // Active with deadline
    }
  }

  String _getProjectStatusText(DateTime? endDate) {
    if (endDate == null) return 'Ongoing';

    final now = DateTime.now();
    if (endDate.isBefore(now)) {
      return 'Completed';
    } else {
      return 'Active';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return '${date.day}/${date.month}/${date.year}';
  }
}
