import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/project_detail_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_create/widgets/task_search_widget.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignTasksSheet extends StatefulWidget {
  final int projectId;
  final String projectName;
  final VoidCallback? onSuccess;

  const AssignTasksSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    this.onSuccess,
  });

  @override
  State<AssignTasksSheet> createState() => _AssignTasksSheetState();
}

class _AssignTasksSheetState extends State<AssignTasksSheet> {
  final ProjectDetailController _projectController = Get.find<ProjectDetailController>();

  List<TaskListModel> _selectedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.assignment_add,
                        color: Color(0xFF6366F1),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Assign Tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'to ${widget.projectName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select tasks to assign to this project:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TaskSearchWidget(
                    selectedTasks: _selectedTasks,
                    onTasksChanged: (tasks) {
                      setState(() {
                        _selectedTasks = tasks;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Obx(() => Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _projectController.assignTasksToProjectController.isLoading.value
                        ? null
                        : () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _projectController.assignTasksToProjectController.isLoading.value || _selectedTasks.isEmpty
                        ? null
                        : _assignTasks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _projectController.assignTasksToProjectController.isLoading.value
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Assigning...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Assign ${_selectedTasks.length} Task${_selectedTasks.length != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  void _assignTasks() async {
    if (_selectedTasks.isEmpty) {
      showCustomSnackbar(
        isSuccess: false,
        title: 'No Tasks Selected',
        message: 'Please select at least one task to assign',
      );
      return;
    }

    final taskIds = _selectedTasks.map((task) => task.id).toList();
    final success = await _projectController.assignTasksToProject(taskIds);

    if (success) {
      Get.back(result: true);
      widget.onSuccess?.call();
      
      showCustomSnackbar(
        isSuccess: true,
        title: 'Success!',
        message: '${_selectedTasks.length} task${_selectedTasks.length != 1 ? 's' : ''} assigned to ${widget.projectName}',
      );
    } else {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Assignment Failed',
        message: _projectController.assignTasksToProjectController.errorMessage.value,
      );
    }
  }
}
