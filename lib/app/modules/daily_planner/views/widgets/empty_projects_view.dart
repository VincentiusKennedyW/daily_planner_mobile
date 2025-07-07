import 'package:flutter/material.dart';

class EmptyTaskOrProjectView extends StatelessWidget {
  final bool isTaskView;
  const EmptyTaskOrProjectView({
    super.key,
    required this.isTaskView,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            isTaskView ? 'Tidak ada Task' : 'Tidak ada Project',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            isTaskView
                ? 'Buat task pertama Anda untuk memulai'
                : 'Buat project pertama Anda untuk memulai',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
