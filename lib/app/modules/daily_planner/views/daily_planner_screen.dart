import 'package:expense_tracker/app/modules/daily_planner/views/task_detail_sheet.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  _DailyPlannerScreenState createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final todayTasks = TaskManager.getTasksForToday();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planning Harian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF6366F1),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Color(0xFF6366F1),
          tabs: [
            Tab(
                text:
                    'To Do (${todayTasks.where((t) => t.status == TaskStatus.todo).length})'),
            Tab(
                text:
                    'Progress (${todayTasks.where((t) => t.status == TaskStatus.inProgress).length})'),
            Tab(
                text:
                    'Done (${todayTasks.where((t) => t.status == TaskStatus.completed).length})'),
            Tab(
                text:
                    'Blocked (${todayTasks.where((t) => t.status == TaskStatus.blocked).length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(
              todayTasks.where((t) => t.status == TaskStatus.todo).toList()),
          _buildTaskList(todayTasks
              .where((t) => t.status == TaskStatus.inProgress)
              .toList()),
          _buildTaskList(todayTasks
              .where((t) => t.status == TaskStatus.completed)
              .toList()),
          _buildTaskList(
              todayTasks.where((t) => t.status == TaskStatus.blocked).toList()),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada task',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Task akan muncul di sini',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index]);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: task.category.color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: task.isOverdue
              ? Colors.red.withOpacity(0.3)
              : task.category.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showTaskDetail(task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: task.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      task.category.icon,
                      color: task.category.color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          task.category.name,
                          style: TextStyle(
                            color: task.category.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleTaskAction(task, value),
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'comment', child: Text('Komentar')),
                      PopupMenuItem(value: 'assign', child: Text('Assign')),
                      PopupMenuItem(value: 'delete', child: Text('Hapus')),
                    ],
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.priority.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
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
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
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
                  Spacer(),
                  if (task.isOverdue)
                    Icon(Icons.warning_rounded, color: Colors.red, size: 16),
                  if (task.dueDate != null) ...[
                    Icon(Icons.schedule_rounded,
                        color: Colors.grey[500], size: 14),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueDate!),
                      style: TextStyle(
                        color: task.isOverdue ? Colors.red : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                    child: Text(
                      task.assignee[0],
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    task.assignee,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${task.category.points} poin',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (task.status != TaskStatus.completed) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _updateTaskStatus(task, TaskStatus.inProgress),
                        icon: Icon(Icons.play_arrow_rounded, size: 16),
                        label: Text('Mulai', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          foregroundColor: Colors.blue,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _updateTaskStatus(task, TaskStatus.completed),
                        icon: Icon(Icons.check_rounded, size: 16),
                        label: Text('Selesai', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.1),
                          foregroundColor: Colors.green,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetail(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(task: task),
    );
  }

  void _handleTaskAction(Task task, String action) {
    switch (action) {
      case 'edit':
        _showEditTaskDialog(task);
        break;
      case 'comment':
        _showAddCommentDialog(task);
        break;
      case 'assign':
        _showAssignDialog(task);
        break;
      case 'delete':
        _showDeleteConfirmation(task);
        break;
    }
  }

  void _updateTaskStatus(Task task, TaskStatus status) {
    setState(() {
      TaskManager.updateTaskStatus(task.id, status);
    });
  }

  void _showAddCommentDialog(Task task) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Komentar'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Tulis komentar...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                TaskManager.addComment(
                  task.id,
                  TaskComment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    author: TaskManager.currentUser,
                    content: commentController.text,
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskManager.userNames.map((user) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                foregroundColor: Color(0xFF6366F1),
                child: Text(user[0]),
              ),
              title: Text(user),
              onTap: () {
                setState(() {
                  TaskManager.assignTask(task.id, user);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Task'),
        content: Text('Apakah Anda yakin ingin menghapus task ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                TaskManager.removeTask(task.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditTaskSheet(task: task),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Besok';
    } else if (difference.inDays == -1) {
      return 'Kemarin';
    } else if (difference.inDays < 0) {
      return '${-difference.inDays} hari lalu';
    } else {
      return '${difference.inDays} hari lagi';
    }
  }
}
