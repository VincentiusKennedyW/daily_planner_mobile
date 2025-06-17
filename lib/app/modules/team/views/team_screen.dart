
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final users = TaskManager.users;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tim', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: users.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final userKey = users.keys.elementAt(index);
          final user = users[userKey]!;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                  child: Text(
                    user.name[0],
                    style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.role,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: user.skills.map((skill) {
                          return Chip(
                            label: Text(skill, style: TextStyle(fontSize: 12)),
                            backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                            labelStyle: TextStyle(color: Color(0xFF6366F1)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.completedTasks} tugas selesai',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${user.totalPoints} poin',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF6366F1)),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        value: user.productivity,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Produktivitas',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
