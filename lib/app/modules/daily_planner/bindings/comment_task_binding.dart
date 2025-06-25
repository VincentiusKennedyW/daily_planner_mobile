import 'package:expense_tracker/app/modules/daily_planner/controllers/comment_task_controller.dart';
import 'package:get/get.dart';

class TaskCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentTaskController>(() => CommentTaskController());
  }
}
