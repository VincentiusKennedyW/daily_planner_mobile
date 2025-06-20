// Widget untuk menampilkan informasi pagination
import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';

class PaginationInfo extends StatelessWidget {
  final Pagination? pagination;
  final TaskStatus status;

  const PaginationInfo({
    Key? key,
    required this.pagination,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pagination == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Halaman ${pagination!.page} dari ${pagination!.totalPages}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Total: ${pagination!.total} task',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk loading state yang lebih menarik
class CustomLoadingIndicator extends StatelessWidget {
  final String message;
  final Color? color;

  const CustomLoadingIndicator({
    Key? key,
    this.message = 'Memuat...',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Color(0xFF6366F1),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk empty state yang lebih menarik
class EmptyTaskState extends StatelessWidget {
  final TaskStatus status;
  final VoidCallback? onRefresh;

  const EmptyTaskState({
    Key? key,
    required this.status,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    String subtitle;
    Color color;

    switch (status) {
      case TaskStatus.todo:
        icon = Icons.assignment_outlined;
        title = 'Belum ada task To Do';
        subtitle = 'Task baru akan muncul di sini';
        color = Colors.blue;
        break;
      case TaskStatus.inProgress:
        icon = Icons.hourglass_empty_outlined;
        title = 'Tidak ada task dalam progress';
        subtitle = 'Task yang sedang dikerjakan akan muncul di sini';
        color = Colors.orange;
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle_outline;
        title = 'Belum ada task selesai';
        subtitle = 'Task yang sudah selesai akan muncul di sini';
        color = Colors.green;
        break;
      case TaskStatus.blocked:
        icon = Icons.block_outlined;
        title = 'Tidak ada task terblokir';
        subtitle = 'Task yang terblokir akan muncul di sini';
        color = Colors.red;
        break;
      default:
        icon = Icons.task_alt_rounded;
        title = 'Tidak ada task';
        subtitle = 'Task akan muncul di sini';
        color = Colors.grey;
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: color,
              ),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh, size: 20),
                label: Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.1),
                  foregroundColor: color,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget untuk error state
class ErrorTaskState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorTaskState({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 20),
              label: Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                foregroundColor: Colors.red,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension untuk TaskStatus agar lebih mudah digunakan
extension TaskStatusExtension on TaskStatus {
  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.blocked:
        return Colors.red;
      case TaskStatus.overdue:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.blocked:
        return 'Blocked';
      case TaskStatus.overdue:
        return 'Overdue';
      default:
        return 'Unknown';
    }
  }
}
