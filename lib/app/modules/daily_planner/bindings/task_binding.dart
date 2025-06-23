import 'package:expense_tracker/app/modules/daily_planner/controllers/complete_task_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:expense_tracker/app/modules/daily_planner/controllers/create_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/start_task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetTaskController>(() => (GetTaskController()));
    Get.lazyPut<CreateTaskController>(() => (CreateTaskController()));
    Get.lazyPut<StartTaskController>(() => (StartTaskController()));
    Get.lazyPut<CompleteTaskController>(() => (CompleteTaskController()));
  }
}
