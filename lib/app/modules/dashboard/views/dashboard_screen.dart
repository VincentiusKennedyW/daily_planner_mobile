import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/auth/controllers/auth_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/leaderboard_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/recent_activity_controller.dart';
import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';
import 'package:expense_tracker/core/task.dart';

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
  final RecentActivityController _recentActivityController =
      Get.find<RecentActivityController>();
  final AuthController _authController = Get.find<AuthController>();

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
    // Sekarang bisa mudah ambil data user
    final userName = _authController.getUserName();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _taskController.getMonthlyTaskStatistics();
          await _taskController.getTotalTaskStatistics();
          await _leaderboardController.getLeaderboard();
        },
        child: CustomScrollView(
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
                              _authController.getUserDepartment() ??
                                  "Departemen tidak tersedia",
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

                  Text(
                    'Aktivitas Terbaru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() {
                    final recentList =
                        _recentActivityController.recentActivities;

                    if (_recentActivityController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (recentList.isEmpty) {
                      return Text("Belum ada aktivitas terbaru.");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        ...recentList
                            .take(3)
                            .map((task) => _buildActivityItem(task)),
                        SizedBox(height: 16),
                      ],
                    );
                  }),
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

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Poin Bulan Ini',
                  _taskController.monthlyTaskStatistics.value?.data.totalPoints
                          .toString() ??
                      '0',
                  Icons.stars_rounded,
                  Color(0xFFF59E0B),
                  'Poin yang didapat bulan ini',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Task Bulan Ini',
                  _taskController.monthlyTaskStatistics.value?.data.total
                          .toString() ??
                      '0',
                  Icons.assignment_rounded,
                  Color(0xFF8B5CF6),
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
                  _taskController.monthlyTaskStatistics.value?.data.completed
                          .toString() ??
                      '0',
                  Icons.check_circle_rounded,
                  Color(0xFF10B981),
                  'Task selesai bulan ini',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Progress',
                  _taskController.monthlyTaskStatistics.value?.data.inProgress
                          .toString() ??
                      '0',
                  Icons.schedule_rounded,
                  Color(0xFF3B82F6),
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

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Poin',
                  _taskController.totalTaskStatistics.value?.data.totalPoints
                          .toString() ??
                      '0',
                  Icons.stars_rounded,
                  Color(0xFFF59E0B),
                  'Total poin yang didapat',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Task',
                  _taskController.totalTaskStatistics.value?.data.total
                          .toString() ??
                      '0',
                  Icons.assignment_rounded,
                  Color(0xFF8B5CF6),
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
                  _taskController.totalTaskStatistics.value?.data.completed
                          .toString() ??
                      '0',
                  Icons.check_circle_rounded,
                  Color(0xFF10B981),
                  'Total task yang selesai',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Progress',
                  _taskController.totalTaskStatistics.value?.data.inProgress
                          .toString() ??
                      '0',
                  Icons.schedule_rounded,
                  Color(0xFF3B82F6),
                  'Total sedang dikerjakan',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

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

  Widget _buildActivityItem(TaskListModel task) {
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
                            Flexible(
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
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
