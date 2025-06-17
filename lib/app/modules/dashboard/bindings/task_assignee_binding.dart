import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';
import 'package:get/get.dart';

class TaskAssigneeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskAssigneeController>(() => TaskAssigneeController());
  }
}
