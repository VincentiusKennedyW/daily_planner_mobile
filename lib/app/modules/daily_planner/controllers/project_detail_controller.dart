import 'package:get/get.dart';

import 'package:expense_tracker/app/data/models/project_models/project_model.dart';
import 'package:expense_tracker/app/data/models/task_models/task_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/assign_tasks_to_project_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/assign_to_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/complete_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_project_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/get_task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/start_task_controller.dart';

class ProjectDetailController extends GetxController {
  final GetTaskController taskController = Get.find<GetTaskController>();
  final StartTaskController startTaskController =
      Get.find<StartTaskController>();
  final CompleteTaskController completeTaskController =
      Get.find<CompleteTaskController>();
  final AssignToTaskController assignToTaskController =
      Get.find<AssignToTaskController>();
  final AssignTasksToProjectController assignTasksToProjectController =
      Get.put(AssignTasksToProjectController());

  late Rx<ProjectModel> project;
  var selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    project = (Get.arguments as ProjectModel).obs;
  }

  void updateProject(ProjectModel updatedProject) {
    project.value = updatedProject;
  }

  List<TaskListModel> get todoTasksForProject {
    if (project.value.tasks == null) return [];
    final projectTaskIds = project.value.tasks!.map((t) => t.id).toSet();
    return taskController.todoTasks
        .where((task) => projectTaskIds.contains(task.id))
        .toList();
  }

  List<TaskListModel> get inProgressTasksForProject {
    if (project.value.tasks == null) return [];
    final projectTaskIds = project.value.tasks!.map((t) => t.id).toSet();
    return taskController.inProgressTasks
        .where((task) => projectTaskIds.contains(task.id))
        .toList();
  }

  List<TaskListModel> get completedTasksForProject {
    if (project.value.tasks == null) return [];
    final projectTaskIds = project.value.tasks!.map((t) => t.id).toSet();
    return taskController.completedTasks
        .where((task) => projectTaskIds.contains(task.id))
        .toList();
  }

  List<TaskListModel> get blockedTasksForProject {
    if (project.value.tasks == null) return [];
    final projectTaskIds = project.value.tasks!.map((t) => t.id).toSet();
    return taskController.blockedTasks
        .where((task) => projectTaskIds.contains(task.id))
        .toList();
  }

  List<TaskListModel> get currentTasks {
    switch (selectedTabIndex.value) {
      case 0:
        return todoTasksForProject;
      case 1:
        return inProgressTasksForProject;
      case 2:
        return [...completedTasksForProject, ...blockedTasksForProject];
      default:
        return todoTasksForProject;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<bool> startTask(int taskId) async {
    return await startTaskController.startTask(taskId);
  }

  Future<bool> completeTask(int taskId) async {
    return await completeTaskController.completeTask(taskId);
  }

  Future<bool> assignToTask(int taskId) async {
    return await assignToTaskController.assignToTask(taskId);
  }

  Future<bool> unassignFromTask(int taskId) async {
    return await assignToTaskController.unassignFromTask(taskId);
  }

  Future<bool> assignTasksToProject(List<int> taskIds) async {
    final updatedProject =
        await assignTasksToProjectController.assignTasksToProject(
      project.value.id,
      taskIds,
    );

    if (updatedProject != null) {
      project.value = updatedProject;

      final GetProjectController? projectController =
          Get.isRegistered<GetProjectController>()
              ? Get.find<GetProjectController>()
              : null;
      if (projectController != null) {
        final index = projectController.projects
            .indexWhere((p) => p.id == project.value.id);
        if (index != -1) {
          projectController.projects[index] = updatedProject;
        }
      }

      return true;
    } else {
      if (assignTasksToProjectController.errorMessage.value.isEmpty) {
        await _refreshProjectData();
        return true;
      }
      return false;
    }
  }

  Future<void> _refreshProjectData() async {
    try {
      final GetProjectController? projectController =
          Get.isRegistered<GetProjectController>()
              ? Get.find<GetProjectController>()
              : null;

      if (projectController != null) {
        await projectController.loadProjects();

        final updatedProject = projectController.projects
            .firstWhereOrNull((p) => p.id == project.value.id);
        if (updatedProject != null) {
          project.value = updatedProject;
        }
      }
    } catch (e) {
      // Fail
    }
  }

  int get totalTasks => project.value.tasks?.length ?? 0;
  int get todoCount => todoTasksForProject.length;
  int get inProgressCount => inProgressTasksForProject.length;
  int get completedCount => completedTasksForProject.length;
  int get blockedCount => blockedTasksForProject.length;

  double get progressPercentage {
    if (totalTasks == 0) return 0.0;
    return completedCount / totalTasks;
  }
}
