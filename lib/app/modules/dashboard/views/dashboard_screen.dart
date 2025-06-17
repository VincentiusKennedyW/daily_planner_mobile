import 'dart:convert';
import 'dart:developer' as developer;

import 'package:expense_tracker/app/modules/dashboard/controllers/leaderboard_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  final TaskAssigneeController _taskController =
      Get.find<TaskAssigneeController>();
  final LeaderboardController _leaderboardController =
      Get.find<LeaderboardController>();

  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = _storage.read('user_data');

    String? userName;
    if (userData != null) {
      try {
        final userMap = userData is String ? json.decode(userData) : userData;
        userName = userMap['name'];
      } catch (e) {
        developer.log(
          'Error parsing user_data: $e',
          name: 'TaskAssigneeController',
        );
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF6366F1),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Selamat ${_getGreeting()},',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            userName ?? "Tidak ada data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            TaskManager.users[TaskManager.currentUser]!.role,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    indicator: BoxDecoration(
                      color: Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Text(
                          'Bulan Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  constraints: BoxConstraints(
                    minHeight: 300, // Minimum height
                    maxHeight: 450, // Maximum height
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Bulan Ini
                      _buildMonthlyStatistics(),
                      // Tab Total
                      _buildTotalStatistics(),
                    ],
                  ),
                ),

                SizedBox(height: 32),
                Text(
                  'Aktivitas Terbaru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Masih pakai data statis untuk aktivitas
                // ...myTasks.take(3).map((task) => _buildActivityItem(task)),
                SizedBox(height: 32),
                Text(
                  'Produktivitas Tim',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Masih pakai data statis untuk produktivitas tim
                _buildTeamProductivityChart(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

// Widget untuk statistik bulanan
  Widget _buildMonthlyStatistics() {
    return Obx(() {
      if (_taskController.isLoadingMonthly.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (_taskController.errorMessageMonthly.value.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                'Error: ${_taskController.errorMessageMonthly.value}',
                style: TextStyle(color: Colors.red[700]),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _taskController.getMonthlyTaskStatistics(),
                child: Text('Coba Lagi'),
              ),
            ],
          ),
        );
      }

      // Gunakan data monthly yang tepat
      final monthlyStatistics = _taskController.monthlyTaskStatistics.value;

      if (monthlyStatistics == null) {
        return Center(
          child: Text('Tidak ada data statistik bulan ini'),
        );
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Poin Bulan Ini',
                  monthlyStatistics.data.totalPoints.toString(),
                  Icons.stars_rounded,
                  Color(0xFFF59E0B),
                  'Poin yang didapat bulan ini',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Task Bulan Ini',
                  monthlyStatistics.data.total.toString(),
                  Icons.assignment_rounded,
                  Color(0xFF3B82F6),
                  'Task yang dibuat bulan ini',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Selesai',
                  monthlyStatistics.data.completed.toString(),
                  Icons.check_circle_rounded,
                  Color(0xFF10B981),
                  'Task selesai bulan ini',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Progress',
                  monthlyStatistics.data.inProgress.toString(),
                  Icons.schedule_rounded,
                  Color(0xFFEF4444),
                  'Sedang dikerjakan',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

// Widget untuk statistik total
  Widget _buildTotalStatistics() {
    return Obx(() {
      // Cek loading state untuk total
      if (_taskController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (_taskController.errorMessage.value.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                'Error: ${_taskController.errorMessage.value}',
                style: TextStyle(color: Colors.red[700]),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _taskController.getTotalTaskStatistics(),
                child: Text('Coba Lagi'),
              ),
            ],
          ),
        );
      }

      // Gunakan data total yang tepat
      final totalStatistics = _taskController.totalTaskStatistics.value;

      if (totalStatistics == null) {
        return Center(
          child: Text('Tidak ada data statistik total'),
        );
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Poin',
                  totalStatistics.data.totalPoints.toString(),
                  Icons.stars_rounded,
                  Color(0xFFF59E0B),
                  'Total poin yang didapat',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Task',
                  totalStatistics.data.total.toString(),
                  Icons.assignment_rounded,
                  Color(0xFF3B82F6),
                  'Total semua task',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Selesai',
                  totalStatistics.data.completed.toString(),
                  Icons.check_circle_rounded,
                  Color(0xFF10B981),
                  'Total task yang selesai',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Progress',
                  totalStatistics.data.inProgress.toString(),
                  Icons.schedule_rounded,
                  Color(0xFFEF4444),
                  'Total sedang dikerjakan',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // ElevatedButton(
  //   onPressed: AuthController.instance.logout,
  //   child: Text('Logout'),
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: Colors.red,
  //   ),
  // ),
  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
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
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  task.category.name,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildTeamProductivityChart() {
    final maxPoints = 100;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          children: _leaderboardController.leaderboard.map((user) {
            final percentage =
                maxPoints > 0 ? user.totalPoints / maxPoints : 0.0;

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${user.totalPoints} poin',
                              style: TextStyle(
                                color: Color(0xFF6366F1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'pagi';
    if (hour < 17) return 'siang';
    return 'sore';
  }
}
