import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = TaskManager.users[TaskManager.currentUser]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
              child: Text(
                user.name[0],
                style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              user.role,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                    'Tugas Selesai', user.completedTasks.toString()),
                _buildStatColumn('Total Poin', user.totalPoints.toString()),
                _buildStatColumn('Produktivitas',
                    '${(user.productivity * 100).toStringAsFixed(1)}%'),
              ],
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Keahlian',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: user.skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                  labelStyle: TextStyle(color: Color(0xFF6366F1)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6366F1)),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
