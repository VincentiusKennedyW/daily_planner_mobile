import 'package:expense_tracker/app/modules/auth/bindings/auth_binding.dart';
import 'package:expense_tracker/app/data/middleware/auth_middleware.dart';
import 'package:expense_tracker/app/modules/auth/views/login_screen.dart';
import 'package:expense_tracker/app/modules/daily_planner/bindings/comment_task_binding.dart';
import 'package:expense_tracker/app/modules/daily_planner/bindings/task_binding.dart';
import 'package:expense_tracker/app/modules/daily_planner/bindings/user_binding.dart';
import 'package:expense_tracker/app/modules/daily_planner/views/task_detail/task_detail_screen.dart';
import 'package:expense_tracker/app/modules/dashboard/bindings/leaderboard_binding.dart';
import 'package:expense_tracker/app/modules/dashboard/bindings/recent_activity_binding.dart';
import 'package:expense_tracker/app/modules/dashboard/bindings/task_assignee_binding.dart';
import 'package:expense_tracker/main.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/login';
  static const String main = '/';
  static const String taskDetail = '/task-detail';

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: main,
      page: () => const MainScreen(),
      bindings: [
        AuthBinding(),
        RecentActivityBinding(),
        TaskBinding(),
        UserBinding(),
        TaskAssigneeBinding(),
        LeaderboardBinding(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: taskDetail,
      page: () => TaskDetailScreen(task: Get.arguments),
      bindings: [
        TaskBinding(),
        UserBinding(),
        TaskAssigneeBinding(),
        TaskCommentBinding(),
      ],
    ),
  ];
}
