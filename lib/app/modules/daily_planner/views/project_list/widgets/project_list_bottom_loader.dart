import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';

Widget buildProjectBottomLoader(bool isLoadingMore) {
  final getProjectController = Get.find<GetProjectController>();

  if (!isLoadingMore) {
    final hasMore = getProjectController.hasNextPage;

    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Tidak ada project lagi',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(height: 8),
          Text(
            'Memuat project...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
