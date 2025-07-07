import 'package:flutter/material.dart';

import 'package:expense_tracker/app/data/models/project_models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final Color projectColor = _getProjectStatusColor(project.endDate);
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
          // TODO: Navigate to project detail
          // Get.toNamed('/project-detail', arguments: project);
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
            _getProjectStatusText(project.endDate),
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
            Icon(
              Icons.play_arrow_rounded,
              size: 16,
              color: Colors.green[600],
            ),
            SizedBox(width: 6),
            Text(
              'Start: ${_formatDate(project.startDate)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (project.startDate != null && project.endDate != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              height: 12,
              width: 1,
              color: Colors.grey[300],
            ),
          if (project.endDate != null) ...[
            Icon(
              Icons.flag_rounded,
              size: 16,
              color: Colors.red[600],
            ),
            SizedBox(width: 6),
            Text(
              'End: ${_formatDate(project.endDate)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
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
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: Colors.orange[700],
              ),
              SizedBox(width: 6),
              Text(
                _getProjectDuration(),
                style: TextStyle(
                  color: Colors.orange[700],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: projectColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: projectColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_rounded,
                size: 14,
                color: projectColor,
              ),
              SizedBox(width: 6),
              Text(
                'View Details',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: projectColor,
                ),
              ),
            ],
          ),
        ),
      ],
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

  String _getProjectDuration() {
    if (project.startDate == null) return 'No timeline';
    
    if (project.endDate == null) {
      final daysSinceStart = DateTime.now().difference(project.startDate!).inDays;
      return '${daysSinceStart}d ongoing';
    }
    
    final duration = project.endDate!.difference(project.startDate!).inDays;
    return '${duration}d duration';
  }

  Color _getProgressColor() {
    final taskCount = project.tasks?.length ?? 0;
    if (taskCount == 0) return Colors.grey;
    
    final now = DateTime.now();
    if (project.endDate != null && project.endDate!.isBefore(now)) {
      return Colors.green; // Completed
    } else if (taskCount > 0) {
      return Colors.blue; // In progress
    } else {
      return Colors.orange; // Pending
    }
  }

  IconData _getProgressIcon() {
    final taskCount = project.tasks?.length ?? 0;
    if (taskCount == 0) return Icons.hourglass_empty_rounded;
    
    final now = DateTime.now();
    if (project.endDate != null && project.endDate!.isBefore(now)) {
      return Icons.check_circle_rounded; // Completed
    } else if (taskCount > 0) {
      return Icons.trending_up_rounded; // In progress
    } else {
      return Icons.pending_rounded; // Pending
    }
  }

  String _getProgressText() {
    final taskCount = project.tasks?.length ?? 0;
    if (taskCount == 0) return 'No tasks';
    
    final now = DateTime.now();
    if (project.endDate != null && project.endDate!.isBefore(now)) {
      return 'Completed';
    } else if (taskCount > 0) {
      return 'In Progress';
    } else {
      return 'Pending';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    return '${date.day}/${date.month}/${date.year}';
  }
}
