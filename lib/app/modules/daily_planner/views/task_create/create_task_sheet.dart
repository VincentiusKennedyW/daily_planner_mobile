import 'package:expense_tracker/app/modules/daily_planner/controllers/create_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/assignee_search_widget.dart';
import 'package:expense_tracker/global_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/search_user_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/bottom_action_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/category_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/deadline_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/header_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/priority_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/tag_widget.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/widgets/title_description_widget.dart';
import 'package:expense_tracker/core/task.dart';

class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet({super.key});

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final CreateTaskController createTaskController =
      Get.find<CreateTaskController>();
  final SearchUserController searchController = Get.put(SearchUserController());

  TaskCategory _selectedCategory = TaskCategory.development;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;
  final List<String> _tags = [];
  List<UserModel> _selectedUsers = [];

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
          const HeaderSection(),
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
                isLoading: createTaskController.isLoadingCreate.value,
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
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _dueDate = date);
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
      status: TaskStatus.todo,
      assignees: assignees,
      dueDate: _dueDate,
      tags: _tags,
      estimatedHours: 1,
      point: _selectedCategory.points,
    );

    final success = await createTaskController.createTask(newTask);
    if (success) {
      Get.back(result: true);
      _clearSearchData();
      showCustomSnackbar(
        isSuccess: true,
        title: 'Berhasil',
        message: 'Task "${_titleController.text}" berhasil dibuat',
      );
    } else {
      showCustomSnackbar(
        isSuccess: false,
        title: 'Gagal',
        message: createTaskController.errorMessageCreate.value,
      );
    }
  }
}
