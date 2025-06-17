import 'dart:math' as math;

import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class AdvancedAddTaskSheet extends StatefulWidget {
  const AdvancedAddTaskSheet({super.key});

  @override
  _AdvancedAddTaskSheetState createState() => _AdvancedAddTaskSheetState();
}

class _AdvancedAddTaskSheetState extends State<AdvancedAddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.development;
  TaskPriority _selectedPriority = TaskPriority.medium;
  String _selectedAssignee = TaskManager.currentUser;
  DateTime? _dueDate;
  int _estimatedHours = 1;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Text(
                  'Buat Planning Baru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Judul Task'),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan judul task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildSectionTitle('Deskripsi'),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Deskripsi detail task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.description_rounded),
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildSectionTitle('Kategori'),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: TaskCategory.values.length,
                      itemBuilder: (context, index) {
                        final category = TaskCategory.values[index];
                        final isSelected = category == _selectedCategory;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? category.color.withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? category.color
                                    : Colors.grey.withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category.icon,
                                  color: isSelected
                                      ? category.color
                                      : Colors.grey[600],
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? category.color
                                        : Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${category.points} poin',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: isSelected
                                        ? category.color
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Prioritas'),
                            DropdownButtonFormField<TaskPriority>(
                              value: _selectedPriority,
                              onChanged: (value) =>
                                  setState(() => _selectedPriority = value!),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.flag_rounded),
                              ),
                              items: TaskPriority.values.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: priority.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(priority.name),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Assign ke'),
                            DropdownButtonFormField<String>(
                              value: _selectedAssignee,
                              onChanged: (value) =>
                                  setState(() => _selectedAssignee = value!),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.person_rounded),
                              ),
                              items: TaskManager.userNames.map((user) {
                                return DropdownMenuItem(
                                  value: user,
                                  child: Text(user),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Tanggal Deadline'),
                            InkWell(
                              onTap: _selectDueDate,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded,
                                        color: Colors.grey[600]),
                                    SizedBox(width: 12),
                                    Text(
                                      _dueDate != null
                                          ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                          : 'Pilih tanggal',
                                      style: TextStyle(
                                        color: _dueDate != null
                                            ? Colors.black87
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Estimasi (jam)'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(() =>
                                      _estimatedHours =
                                          math.max(1, _estimatedHours - 1)),
                                  icon: Icon(Icons.remove_circle_outline),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$_estimatedHours jam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      setState(() => _estimatedHours++),
                                  icon: Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  _buildSectionTitle('Tags'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: InputDecoration(
                            hintText: 'Tambah tag...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.tag_rounded),
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _addTag(_tagController.text),
                        icon: Icon(Icons.add_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                          foregroundColor: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  if (_tags.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => setState(() => _tags.remove(tag)),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Batal'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Buat Planning'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _createTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul task tidak boleh kosong')),
      );
      return;
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      priority: _selectedPriority,
      assignee: _selectedAssignee,
      createdAt: DateTime.now(),
      dueDate: _dueDate,
      tags: _tags,
      estimatedHours: _estimatedHours,
    );

    TaskManager.addTask(task);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planning berhasil dibuat!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
