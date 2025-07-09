import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/complete_project_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/project_detail_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_detail/widgets/assign_tasks_sheet.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_detail/widgets/project_detail_header.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_detail/widgets/project_stats_card.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_detail/widgets/project_task_tabs.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectDetailController controller = Get.find<ProjectDetailController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final project = controller.project.value;

        return Column(
          children: [
            ProjectDetailHeader(project: controller.project.value),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (project.endDate != null &&
                        project.endDate!.isBefore(DateTime.now()))
                      ...[],
                    if (project.startDate == null ||
                        project.endDate == null) ...[
                      _buildProjectActionsCard(controller),
                      const SizedBox(height: 16),
                    ],
                    ProjectStatsCard(controller: controller),
                    const SizedBox(height: 16),
                    _buildAssignTasksCard(controller),
                    const SizedBox(height: 16),
                    ProjectTaskTabs(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProjectActionsCard(ProjectDetailController controller) {
    final CompleteProjectController completeController =
        Get.put(CompleteProjectController());
    final project = controller.project.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Project Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (project.startDate == null) ...[
            _buildActionItem(
              title: 'Tanggal Mulai',
              subtitle: 'Kapan project ini dimulai?',
              icon: Icons.play_arrow_rounded,
              color: Colors.blue,
              onTap: () => _selectStartDate(completeController, project.id),
              isLoading: completeController.isLoading.value,
            ),
          ] else if (project.endDate == null) ...[
            _buildActionItem(
              title: 'Tanggal Selesai',
              subtitle: 'Kapan project ini selesai?',
              icon: Icons.event_rounded,
              color: Colors.orange,
              onTap: () => _selectEndDate(completeController, project.id),
              isLoading: completeController.isLoading.value,
            ),
            // const SizedBox(height: 12),
            // _buildActionItem(
            //   title: 'Complete Now',
            //   subtitle: 'Mark this project as finished immediately',
            //   icon: Icons.check_circle_rounded,
            //   color: Colors.green,
            //   onTap: () => _completeProject(completeController, project),
            //   isLoading: completeController.isLoading.value,
            // ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: color,
                          ),
                        )
                      : Icon(
                          icon,
                          color: color,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignTasksCard(ProjectDetailController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_add,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Task Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionItem(
            title: 'Assign Tasks',
            subtitle: 'Add more tasks to this project',
            icon: Icons.assignment_add,
            color: Colors.green,
            onTap: () => _showAssignTasksSheet(controller),
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void _selectStartDate(
      CompleteProjectController completeController, int projectId) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      final selectedDate = DateTime(date.year, date.month, date.day);
      final success =
          await completeController.setProjectStartDate(projectId, selectedDate);
      if (success) {
        showCustomSnackbar(
          isSuccess: true,
          title: 'Berhasil!',
          message: 'Tanggal mulai project berhasil diatur',
        );
      } else {
        showCustomSnackbar(
          isSuccess: false,
          title: 'Ups, Ada Masalah!',
          message: completeController.errorMessage.value,
        );
      }
    }
  }

  void _selectEndDate(
      CompleteProjectController completeController, int projectId) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      final selectedDate =
          DateTime(date.year, date.month, date.day, 23, 59, 59);
      final success =
          await completeController.setProjectEndDate(projectId, selectedDate);
      if (success) {
        showCustomSnackbar(
          isSuccess: true,
          title: 'Berhasil!',
          message: 'Tanggal selesai project berhasil diatur',
        );
      } else {
        showCustomSnackbar(
          isSuccess: false,
          title: 'Ups, Ada Masalah!',
          message: completeController.errorMessage.value,
        );
      }
    }
  }

  void _showAssignTasksSheet(ProjectDetailController controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssignTasksSheet(
        projectId: controller.project.value.id,
        projectName: controller.project.value.name,
        onSuccess: () {
          // The controller.assignTasksToProject already handles reactive updates
          // No additional action needed here since the reactive state will auto-update the UI
        },
      ),
    );
  }
}
