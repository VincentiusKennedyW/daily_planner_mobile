import 'dart:math' as math;

import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class EditTaskSheet extends StatefulWidget {
  final Task task;
  const EditTaskSheet({super.key, required this.task});

  @override
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskCategory _selectedCategory;
  late TaskPriority _selectedPriority;
  late String _selectedAssignee;
  DateTime? _dueDate;
  late int _estimatedHours;
  late List<String> _tags;
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);
    _selectedCategory = task.category;
    _selectedPriority = task.priority;
    _selectedAssignee = task.assignee;
    _dueDate = task.dueDate;
    _estimatedHours = task.estimatedHours;
    _tags = List.from(task.tags);
  }

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
                  'Edit Planning',
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
                    onPressed: _updateTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Update Planning'),
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
      initialDate: _dueDate ?? DateTime.now(),
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

  void _updateTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul task tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      final task = widget.task;
      task.title = _titleController.text;
      task.description = _descriptionController.text;
      task.category = _selectedCategory;
      task.priority = _selectedPriority;
      task.assignee = _selectedAssignee;
      task.dueDate = _dueDate;
      task.estimatedHours = _estimatedHours;
      task.tags = _tags;
    });

    TaskManager.updateUserStats();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planning berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class TaskDetailSheet extends StatelessWidget {
  final Task task;

  const TaskDetailSheet({super.key, required this.task});

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
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: task.category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    task.category.icon,
                    color: task.category.color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        task.category.name,
                        style: TextStyle(
                          color: task.category.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty) ...[
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.flag_rounded,
                        label: 'Prioritas: ${task.priority.name}',
                        color: task.priority.color,
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.schedule_rounded,
                        label: task.dueDate != null
                            ? 'Deadline: ${_formatDate(task.dueDate!)}'
                            : 'No deadline',
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Status: ${task.status.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: task.status.color,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Assign ke',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                      child: Text(
                        task.assignee[0],
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(task.assignee),
                    subtitle:
                        Text(TaskManager.users[task.assignee]?.role ?? ''),
                  ),
                  SizedBox(height: 16),
                  if (task.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: task.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                          labelStyle: TextStyle(color: Color(0xFF6366F1)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                  ],
                  Text(
                    'Komentar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (task.comments.isEmpty)
                    Text(
                      'Belum ada komentar',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    Column(
                      children: task.comments.map((comment) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                            child: Text(
                              comment.author[0],
                              style: TextStyle(
                                color: Color(0xFF6366F1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(comment.author),
                          subtitle: Text(comment.content),
                          trailing: Text(
                            _formatDateTime(comment.createdAt),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
