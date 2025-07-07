import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/core/task.dart'; // Import for extensions
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskSearchWidget extends StatefulWidget {
  final List<TaskListModel> selectedTasks;
  final Function(List<TaskListModel>) onTasksChanged;

  const TaskSearchWidget({
    super.key,
    required this.selectedTasks,
    required this.onTasksChanged,
  });

  @override
  State<TaskSearchWidget> createState() => _TaskSearchWidgetState();
}

class _TaskSearchWidgetState extends State<TaskSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final GetTaskController taskController = Get.find<GetTaskController>();
  List<TaskListModel> _filteredTasks = [];
  late List<TaskListModel> _selectedTasks;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedTasks = List.from(widget.selectedTasks);
    // Don't load tasks initially - only when user searches
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSelectedTasks() {
    widget.onTasksChanged(_selectedTasks);
  }

  void _filterTasks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTasks = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API delay untuk consistency dengan AssigneeSearchWidget
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredTasks = [
            ...taskController.todoTasks,
            ...taskController.inProgressTasks,
            ...taskController.completedTasks,
            ...taskController.blockedTasks,
          ].where((task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase())
          ).toList();
          _isLoading = false;
        });
      }
    });
  }

  void _toggleTaskSelection(TaskListModel task) {
    setState(() {
      final isSelected = _selectedTasks.any((t) => t.id == task.id);
      if (isSelected) {
        _selectedTasks.removeWhere((t) => t.id == task.id);
      } else {
        _selectedTasks.add(task);
      }
    });
    _updateSelectedTasks();
  }

  void _removeTask(TaskListModel task) {
    setState(() {
      _selectedTasks.removeWhere((t) => t.id == task.id);
    });
    _updateSelectedTasks();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredTasks = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(),
        const SizedBox(height: 16),
        if (_selectedTasks.isNotEmpty) ...[
          _buildSelectedTasksSection(),
          const SizedBox(height: 16),
        ],
        _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari task berdasarkan judul atau deskripsi...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 16,
                  height: 16,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: _clearSearch,
                ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: _filterTasks,
      ),
    );
  }

  Widget _buildSelectedTasksSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text(
                'Task Terpilih (${_selectedTasks.length}):',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTasks.map((task) => _buildSelectedTaskChip(task)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTaskChip(TaskListModel task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: task.category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              task.category.icon,
              size: 10,
              color: task.category.color,
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeTask(task),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading && _searchController.text.isNotEmpty) {
      return _buildLoadingState();
    }

    if (_filteredTasks.isEmpty && _searchController.text.isNotEmpty && !_isLoading) {
      return _buildNoResultsState();
    }

    if (_filteredTasks.isNotEmpty) {
      return _buildResultsList();
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
          SizedBox(height: 12),
          Text(
            'Mencari task...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 6, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Task tidak ditemukan',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Coba gunakan kata kunci lain',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredTasks.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final task = _filteredTasks[index];
          final isSelected = _selectedTasks.any((t) => t.id == task.id);

          return _buildTaskListItem(task, isSelected, index);
        },
      ),
    );
  }

  Widget _buildTaskListItem(TaskListModel task, bool isSelected, int index) {
    return InkWell(
      onTap: () => _toggleTaskSelection(task),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.08) : Colors.transparent,
          borderRadius: _getItemBorderRadius(index),
        ),
        child: Row(
          children: [
            _buildCheckbox(isSelected),
            const SizedBox(width: 12),
            _buildTaskIcon(task),
            const SizedBox(width: 12),
            _buildTaskInfo(task),
            if (isSelected) _buildSelectedIndicator(),
          ],
        ),
      ),
    );
  }

  BorderRadius _getItemBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (index == _filteredTasks.length - 1) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }
    return BorderRadius.zero;
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.withOpacity(0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            )
          : null,
    );
  }

  Widget _buildTaskIcon(TaskListModel task) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: task.category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        task.category.icon,
        color: task.category.color,
        size: 20,
      ),
    );
  }

  Widget _buildTaskInfo(TaskListModel task) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: task.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.status.name,
                  style: TextStyle(
                    color: task.status.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: task.priority.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.priority.name,
                  style: TextStyle(
                    color: task.priority.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Dipilih',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
