import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAvailableTasks();
  }

  void _loadAvailableTasks() {
    // Load all tasks from different status
    _filteredTasks = [
      ...taskController.todoTasks,
      ...taskController.inProgressTasks,
      ...taskController.completedTasks,
      ...taskController.blockedTasks,
    ];
    setState(() {});
  }

  void _filterTasks(String query) {
    if (query.isEmpty) {
      _loadAvailableTasks();
      return;
    }

    setState(() {
      _filteredTasks = [
        ...taskController.todoTasks,
        ...taskController.inProgressTasks,
        ...taskController.completedTasks,
        ...taskController.blockedTasks,
      ].where((task) =>
          task.title.toLowerCase().contains(query.toLowerCase()) ||
          (task.description.toLowerCase().contains(query.toLowerCase()))
      ).toList();
    });
  }

  void _addTask(TaskListModel task) {
    if (!widget.selectedTasks.any((t) => t.id == task.id)) {
      final updatedTasks = [...widget.selectedTasks, task];
      widget.onTasksChanged(updatedTasks);
    }
  }

  void _removeTask(TaskListModel task) {
    final updatedTasks = widget.selectedTasks.where((t) => t.id != task.id).toList();
    widget.onTasksChanged(updatedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assign Tasks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        
        // Search Field
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterTasks,
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Selected Tasks
        if (widget.selectedTasks.isNotEmpty) ...[
          const Text(
            'Selected Tasks:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTasks.map((task) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTask(task),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Available Tasks List
        if (_searchController.text.isNotEmpty && _filteredTasks.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                final isSelected = widget.selectedTasks.any((t) => t.id == task.id);
                
                return ListTile(
                  title: Text(
                    task.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: task.description.isNotEmpty
                      ? Text(
                          task.description,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                      : const Icon(Icons.add_circle_outline, color: Color(0xFF6B7280)),
                  onTap: isSelected ? null : () => _addTask(task),
                  enabled: !isSelected,
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
