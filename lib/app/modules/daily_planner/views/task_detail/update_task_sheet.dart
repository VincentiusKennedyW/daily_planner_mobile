import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/search_user_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/update_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/assignee_search_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/bottom_action_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/category_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/deadline_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/header_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/priority_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/title_description_widget.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';

class UpdateTaskSheet extends StatefulWidget {
  final TaskListModel task;

  const UpdateTaskSheet({super.key, required this.task});

  @override
  State<UpdateTaskSheet> createState() => UpdateTaskSheetState();
}

class UpdateTaskSheetState extends State<UpdateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final UpdateTaskController _updateTaskController =
      Get.find<UpdateTaskController>();
  final SearchUserController searchController = Get.put(SearchUserController());
  final CommentTaskController _commentTaskController =
      Get.find<CommentTaskController>();

  TaskCategory _selectedCategory = TaskCategory.development;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;
  final List<String> _tags = [];
  List<UserModel> _selectedUsers = [];

  @override
  void initState() {
    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Use the current task from CommentTaskController which might have latest data
      final latestTask = _commentTaskController.currentTask.value ?? widget.task;
      _initializeTaskData(latestTask);
    });
  }

  void _initializeTaskData(TaskListModel task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedCategory = task.category;
    _selectedPriority = task.priority;
    _dueDate = task.dueDate;
    _tags.clear();
    _tags.addAll(task.tags ?? []);
    _selectedUsers = List.from(task.assignees ?? []);
  }

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
            isEditing: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleDescriptionSection(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                  ),
                  const SizedBox(height: 20),
                  CategorySection(
                    selectedCategory: _selectedCategory,
                    onSelectCategory: (cat) =>
                        setState(() => _selectedCategory = cat),
                  ),
                  const SizedBox(height: 24),
                  PrioritySection(
                    selectedPriority: _selectedPriority,
                    onSelectPriority: (pri) =>
                        setState(() => _selectedPriority = pri),
                  ),
                  const SizedBox(height: 24),
                  AssigneeSearchWidget(
                    selectedUsers: _selectedUsers,
                    onUsersChanged: (users) {
                      setState(() {
                        _selectedUsers = users;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  DeadlineSection(
                    dueDate: _dueDate,
                    onSelectDate: _selectDueDate,
                  ),
                  const SizedBox(height: 16),
                  // TagSection(
                  //   tags: _tags,
                  //   onAddTag: (tag) => setState(() => _tags.add(tag)),
                  //   onRemoveTag: (tag) => setState(() => _tags.remove(tag)),
                  // ),
                  // const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Obx(() => BottomActionSection(
                isLoading: _updateTaskController.isLoadingUpdate.value,
                onCancel: () {
                  Get.back();
                  _clearSearchData();
                },
                onSubmit: _submitTask,
              )),
        ],
      ),
    );
  }

  void _selectDueDate() async {
    final now = DateTime.now();
    final initialDate =
        _dueDate != null && _dueDate!.isAfter(now) ? _dueDate! : now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      final selectedDate = DateTime(date.year, date.month, date.day);
      setState(() => _dueDate = selectedDate);
    }
  }

  void _clearSearchData() {
    _selectedUsers.clear();
    searchController.users.clear();
  }

  void _submitTask() async {
    if (_titleController.text.trim().isEmpty) {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Judul Kosong',
        message: 'Judul task tidak boleh kosong',
      );
      return;
    }

    final assignees = _selectedUsers.map((e) => e.id).whereType<int>().toList();
    final newTask = CreateTaskModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      status: widget.task.status,
      assignees: assignees,
      dueDate: _dueDate,
      tags: _tags,
      estimatedHours: 1,
      point: _selectedCategory.points,
    );

    final success = await _updateTaskController.updateTask(
      widget.task.id,
      newTask,
    );
    if (success) {
      // Get the updated task from CommentTaskController which should have the latest data
      final updatedTask = _commentTaskController.currentTask.value;
      
      Get.back(result: updatedTask ?? true);
      _clearSearchData();
      showCustomSnackbar(
        isSuccess: true,
        title: 'Berhasil',
        message: 'Task "${_titleController.text}" berhasil diperbarui',
      );
    } else {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Gagal',
        message: _updateTaskController.errorMessageUpdate.value,
      );
    }
  }
}
