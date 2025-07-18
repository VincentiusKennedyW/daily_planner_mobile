import 'package:expense_tracker/app/modules/daily_planner/controllers/project_detail_controller.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/data/models/project_models/project_model.dart';

class ProjectDetailHeader extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final ProjectDetailController controller =
        Get.find<ProjectDetailController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final currentProject = controller.project.value;
                final Color projectColor = _getProjectStatusColor(
                    currentProject.startDate, currentProject.endDate);

                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Project #${project.projectNo}',
                            style: TextStyle(
                              fontSize: 14,
                              color: projectColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: projectColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getProjectStatusText(
                            project.startDate, project.endDate),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: projectColor,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Obx(() {
                final currentProject = controller.project.value;
                final Color projectColor = _getProjectStatusColor(
                    currentProject.startDate, currentProject.endDate);
                if (project.startDate != null || project.endDate != null) {
                  return _buildDateSection(projectColor);
                }
                return const SizedBox.shrink();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(Color projectColor) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (project.startDate != null) ...[
            Expanded(
              child: Text(
                'Start: ${_formatDate(project.startDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (project.startDate != null && project.endDate != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 12,
              width: 1,
              color: Colors.grey[300],
            ),
          ],
          if (project.endDate != null) ...[
            Expanded(
              child: Text(
                'End: ${_formatDate(project.endDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getProjectStatusColor(DateTime? startDate, DateTime? endDate) {
    // final bool allTasksCompleted = _areAllTasksCompleted();
    final now = DateTime.now();

    // if (allTasksCompleted) {
    //   return 'Completed';
    // }

    if ((startDate != null && startDate.isAfter(now)) ||
        startDate == null && endDate == null) {
      return Colors.purple;
    }

    if (endDate == null) {
      return Colors.blue;
    } else if (endDate.isBefore(now)) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  String _getProjectStatusText(DateTime? startDate, DateTime? endDate) {
    final bool allTasksCompleted = _areAllTasksCompleted();
    final now = DateTime.now();

    if ((startDate != null && startDate.isAfter(now)) ||
        startDate == null && endDate == null) {
      return 'Upcoming';
    } else if (endDate == null) {
      return 'In Progress';
    } else if (endDate.isBefore(now)) {
      return 'Overdue';
    } else if (startDate != null && allTasksCompleted) {
      return 'Completed';
    } else {
      return 'Active';
    }
  }

  bool _areAllTasksCompleted() {
    final tasks = project.tasks;
    if (tasks == null || tasks.isEmpty) return false;

    return tasks.every((task) => task.status == TaskStatus.completed);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return '${date.day}/${date.month}/${date.year}';
  }
}
