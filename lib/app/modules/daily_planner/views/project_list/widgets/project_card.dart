import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/core/task.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final Color projectColor =
        _getProjectStatusColor(project.startDate, project.endDate);
    final int taskCount = project.tasks?.length ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: projectColor.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: projectColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/project-detail', arguments: project);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(projectColor),
              SizedBox(height: 16),
              if (project.startDate != null || project.endDate != null) ...[
                _buildDateSection(),
                SizedBox(height: 16),
              ],
              _buildStatsRow(taskCount),
              SizedBox(height: 16),
              _buildBottomRow(projectColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color projectColor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: projectColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.folder_open_rounded,
            color: projectColor,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Project #${project.projectNo}',
                style: TextStyle(
                  color: projectColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: projectColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getProjectStatusText(project.startDate, project.endDate),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: projectColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
              margin: EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildStatsRow(int taskCount) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_rounded,
                size: 14,
                color: Color(0xFF6366F1),
              ),
              SizedBox(width: 6),
              Text(
                '$taskCount Task${taskCount != 1 ? 's' : ''}',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _getProgressColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getProgressIcon(),
                size: 14,
                color: _getProgressColor(),
              ),
              SizedBox(width: 6),
              Text(
                _getProgressText(),
                style: TextStyle(
                  color: _getProgressColor(),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(Color projectColor) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 14,
          color: Colors.grey[500],
        ),
        SizedBox(width: 6),
        Text(
          'Created ${_formatDate(project.createdAt)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: projectColor.withOpacity(0.7),
        ),
      ],
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

  Color _getProgressColor() {
    final bool allTasksCompleted = _areAllTasksCompleted();
    final taskCount = project.tasks?.length ?? 0;

    if (taskCount == 0) return Colors.grey;

    if (allTasksCompleted) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  IconData _getProgressIcon() {
    final bool allTasksCompleted = _areAllTasksCompleted();
    final taskCount = project.tasks?.length ?? 0;

    if (taskCount == 0) return Icons.hourglass_empty_rounded;

    if (allTasksCompleted) {
      return Icons.check_circle_rounded;
    } else {
      return Icons.trending_up_rounded;
    }
  }

  String _getProgressText() {
    final bool allTasksCompleted = _areAllTasksCompleted();
    final taskCount = project.tasks?.length ?? 0;

    if (taskCount == 0) return 'No tasks';

    if (allTasksCompleted) {
      return 'Completed';
    } else {
      return 'In Progress';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return '${date.day}/${date.month}/${date.year}';
  }
}
