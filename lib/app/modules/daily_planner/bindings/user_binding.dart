import 'package:expense_tracker/app/modules/daily_planner/controllers/search_user_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchUserController>(() => SearchUserController());
  }
}
