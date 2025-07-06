import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetProjectController>(() => (GetProjectController()));
  }
}
