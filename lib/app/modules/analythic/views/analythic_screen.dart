import 'dart:math' as math;

import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now();
    final monthlyPoints =
        TaskManager.getMonthlyPoints(currentMonth.year, currentMonth.month);
    final totalPoints = monthlyPoints.values.fold(0, (a, b) => a + b);

    final statusCounts = {
      TaskStatus.todo: 0,
      TaskStatus.inProgress: 0,
      TaskStatus.completed: 0,
      TaskStatus.blocked: 0,
    };

    for (var task in TaskManager.tasks) {
      statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Poin Bulan Ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text(
              '$totalPoints poin',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1)),
            ),
            SizedBox(height: 24),
            Text('Status Tugas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: statusCounts.entries.map((entry) {
                return _buildStatusCard(entry.key, entry.value);
              }).toList(),
            ),
            SizedBox(height: 32),
            Text('Poin Per Anggota',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(child: _buildPointsBarChart(monthlyPoints)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(TaskStatus status, int count) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 80,
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
              status == TaskStatus.todo
                  ? Icons.list_alt_rounded
                  : status == TaskStatus.inProgress
                      ? Icons.autorenew_rounded
                      : status == TaskStatus.completed
                          ? Icons.check_circle_rounded
                          : Icons.block_rounded,
              color: status.color,
              size: 28),
          SizedBox(height: 8),
          Text(
            status.name,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: status.color),
          ),
          SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBarChart(Map<String, int> points) {
    if (points.isEmpty) {
      return Center(child: Text('Belum ada data poin'));
    }
    final maxPoints = points.values.reduce(math.max);

    return ListView(
      children: points.entries.map((entry) {
        final user = entry.key;
        final userPoints = entry.value;
        final percentage = maxPoints > 0 ? userPoints / maxPoints : 0.0;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                child: Text(
                  user[0],
                  style: TextStyle(
                      color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '$userPoints',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Text(user, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
