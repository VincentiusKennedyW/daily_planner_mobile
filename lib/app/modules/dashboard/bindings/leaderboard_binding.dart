import 'package:expense_tracker/app/modules/dashboard/controllers/leaderboard_controller.dart';
import 'package:get/get.dart';

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
  }
}
