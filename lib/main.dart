import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:expense_tracker/app/modules/analythic/views/analythic_screen.dart';
import 'package:expense_tracker/app/modules/auth/bindings/auth_binding.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/project_create/create_project_sheet.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_create/create_task_sheet.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_list/task_list_screen.dart';
import 'package:expense_tracker/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:expense_tracker/app/modules/profile/views/profile_screen.dart';
import 'package:expense_tracker/app/modules/team/views/team_screen.dart';
import 'package:expense_tracker/app/routes/routes.dart';
import 'package:expense_tracker/core/base_http_service.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:expense_tracker/core/user.dart';
import 'package:expense_tracker/global_widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await initServices();

  runApp(RDPlannerApp());
}

Future<void> initServices() async {
  Get.put<BaseService>(BaseService(), permanent: true);
}

class RDPlannerApp extends StatelessWidget {
  const RDPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'R&D Daily Planner',
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      initialRoute: '/dashboard',
      getPages: AppRoutes.routes,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize GetStorage
//   await GetStorage.init();

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter GetX Auth',
//       debugShowCheckedModeBanner: false,
//       initialBinding: AuthBinding(),
//       initialRoute: '/dashboard',
//       getPages: AppRoutes.routes,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//     );
//   }
// }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      screen: DashboardScreen(),
    ),
    NavigationItem(
      icon: Icons.today_rounded,
      label: 'Planning',
      screen: DailyPlannerScreen(),
    ),
    NavigationItem(
      icon: Icons.analytics_rounded,
      label: 'Analytics',
      screen: AnalyticsScreen(),
    ),
    NavigationItem(
      icon: Icons.group_rounded,
      label: 'Team',
      screen: TeamScreen(),
    ),
    NavigationItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      screen: ProfileScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    TaskManager.updateUserStats();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
    return Scaffold(
      extendBody: false,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: _navigationItems[_selectedIndex].screen,
      ),
      bottomNavigationBar: FloatingBubbleBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _navigationItems
            .map((navItem) => BottomNavItem(
                  icon: navItem.icon,
                  label: navItem.label,
                ))
            .toList(),
      ),
      floatingActionButton: _selectedIndex == 1
          ? ScaleTransition(
              scale: _fabAnimation,
              child: ExpandableFab(
                distance: 60.0,
                overlayStyle: ExpandableFabOverlayStyle(
                  blur: 6.0,
                  color: Colors.white.withOpacity(0.2),
                ),
                type: ExpandableFabType.up,
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                  child: const Icon(Icons.add),
                  fabSize: ExpandableFabSize.regular,
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                  child: const Icon(Icons.close_rounded),
                  fabSize: ExpandableFabSize.small,
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                childrenAnimation: ExpandableFabAnimation.none,
                children: [
                  Row(
                    children: [
                      Text(
                        'Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.small(
                        heroTag: "task",
                        onPressed: () => _showAddTaskDialog(context),
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.task),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Project',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.small(
                        heroTag: "project",
                        onPressed: () => _showAddProjectDialog(context),
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.drive_folder_upload_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskSheet(),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateProjectSheet(),
    );
  }
}

class TaskManager {
  static final List<Task> _tasks = [];
  static final Map<String, UserProfile> _users = {
    'Andi': UserProfile(
        name: 'Andi Pratama',
        role: 'Senior Developer',
        skills: ['Flutter', 'React', 'Node.js']),
    'Budi': UserProfile(
        name: 'Budi Santoso',
        role: 'Backend Developer',
        skills: ['Java', 'Spring Boot', 'MySQL']),
    'Citra': UserProfile(
        name: 'Citra Dewi',
        role: 'UI/UX Designer',
        skills: ['Figma', 'Adobe XD', 'Prototyping']),
    'Dina': UserProfile(
        name: 'Dina Sari',
        role: 'QA Engineer',
        skills: ['Testing', 'Automation', 'Selenium']),
    'Eka': UserProfile(
        name: 'Eka Putra',
        role: 'DevOps Engineer',
        skills: ['Docker', 'Kubernetes', 'AWS']),
  };
  static String currentUser = 'Andi';

  static List<Task> get tasks => _tasks;
  static Map<String, UserProfile> get users => _users;
  static List<String> get userNames => _users.keys.toList();

  static void addTask(Task task) {
    _tasks.add(task);
    updateUserStats();
  }

  static void updateTaskStatus(String taskId, TaskStatus status) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].status = status;
      if (status == TaskStatus.completed &&
          _tasks[taskIndex].completedAt == null) {
        _tasks[taskIndex].completedAt = DateTime.now();
      }
      updateUserStats();
    }
  }

  static void assignTask(String taskId, String assignee) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].assignee = assignee;
    }
  }

  static void addComment(String taskId, TaskComment comment) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].comments.add(comment);
    }
  }

  static void removeTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    updateUserStats();
  }

  static List<Task> getTasksForToday() {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            task.createdAt.year == today.year &&
            task.createdAt.month == today.month &&
            task.createdAt.day == today.day)
        .toList();
  }

  static List<Task> getTasksByUser(String user) {
    return _tasks.where((task) => task.assignee == user).toList();
  }

  static List<Task> getOverdueTasks() {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  static Map<String, int> getMonthlyPoints(int year, int month) {
    final monthlyTasks = _tasks.where((task) =>
        task.completedAt != null &&
        task.completedAt!.year == year &&
        task.completedAt!.month == month);

    Map<String, int> userPoints = {};
    for (String user in userNames) {
      userPoints[user] = 0;
    }

    for (Task task in monthlyTasks) {
      userPoints[task.assignee] =
          (userPoints[task.assignee] ?? 0) + task.points;
    }

    return userPoints;
  }

  static void updateUserStats() {
    for (String userName in userNames) {
      final userTasks = getTasksByUser(userName);
      final completedTasks =
          userTasks.where((task) => task.status == TaskStatus.completed).length;
      final totalPoints = userTasks.fold(0, (sum, task) => sum + task.points);
      final productivity =
          userTasks.isEmpty ? 0.0 : completedTasks / userTasks.length;

      _users[userName]!.completedTasks = completedTasks;
      _users[userName]!.totalPoints = totalPoints;
      _users[userName]!.productivity = productivity;
    }
  }
}
