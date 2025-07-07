import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/project_models/create_project_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/create_project_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_create/widgets/task_search_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_create/widgets/date_range_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/bottom_action_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/header_widget.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class CreateProjectSheet extends StatefulWidget {
  final VoidCallback? onSuccess;
  
  const CreateProjectSheet({super.key, this.onSuccess});

  @override
  State<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<CreateProjectSheet> {
  final _projectNameController = TextEditingController();
  final _projectNumberController = TextEditingController();

  final CreateProjectController createProjectController =
      Get.put(CreateProjectController());
  final GetTaskController taskController = Get.find<GetTaskController>();

  List<TaskListModel> _selectedTasks = [];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const HeaderSection(
            isEditing: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Name Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Project Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _projectNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter project name...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.work_outline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Project Number Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Project Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _projectNumberController,
                        decoration: InputDecoration(
                          hintText: 'Enter project number...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DateRangeSection(
                    startDate: _startDate,
                    endDate: _endDate,
                    onSelectStartDate: _selectStartDate,
                    onSelectEndDate: _selectEndDate,
                  ),
                  const SizedBox(height: 24),
                  TaskSearchWidget(
                    selectedTasks: _selectedTasks,
                    onTasksChanged: (tasks) {
                      setState(() {
                        _selectedTasks = tasks;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Obx(
            () => BottomActionSection(
              isLoading: createProjectController.isLoadingCreate.value,
              onCancel: () {
                Get.back();
                _clearData();
              },
              onSubmit: _submitProject,
            ),
          ),
        ],
      ),
    );
  }

  void _selectStartDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      final selectedDate = DateTime(date.year, date.month, date.day);
      setState(() => _startDate = selectedDate);

      // If end date is before start date, clear it
      if (_endDate != null && _endDate!.isBefore(selectedDate)) {
        setState(() => _endDate = null);
      }
    }
  }

  void _selectEndDate() async {
    final now = DateTime.now();
    final firstDate = _startDate ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? firstDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      final selectedDate = DateTime(date.year, date.month, date.day);
      setState(() => _endDate = selectedDate);
    }
  }

  void _clearData() {
    _selectedTasks.clear();
  }

  void _submitProject() async {
    if (_projectNameController.text.trim().isEmpty) {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Nama Project Kosong',
        message: 'Nama project tidak boleh kosong',
      );
      return;
    }

    if (_projectNumberController.text.trim().isEmpty) {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Nomor Project Kosong',
        message: 'Nomor project tidak boleh kosong',
      );
      return;
    }

    final taskIds = _selectedTasks.map((e) => e.id).toList();
    final newProject = CreateProjectModel(
      name: _projectNameController.text.trim(),
      projectNo: _projectNumberController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      taskIds: taskIds,
    );

    final success = await createProjectController.createProject(newProject);
    if (success) {
      Get.back(result: true);
      _clearData();
      widget.onSuccess?.call(); // Close FAB
      showCustomSnackbar(
        isSuccess: true,
        title: 'Berhasil',
        message: 'Project "${_projectNameController.text}" berhasil dibuat',
      );
    } else {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Gagal',
        message: createProjectController.errorMessageCreate.value,
      );
    }
  }
}
