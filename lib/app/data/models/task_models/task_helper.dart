import 'package:expense_tracker/core/task.dart';

class TaskModelHelper {
  static TaskCategory parseTaskCategory(String category) {
    switch (category.toUpperCase()) {
      case 'RISET':
        return TaskCategory.riset;
      case 'BOQ':
        return TaskCategory.boq;
      case 'DEVELOPMENT':
        return TaskCategory.development;
      case 'IMPLEMENTATION':
        return TaskCategory.implementation;
      case 'MAINTENANCE':
        return TaskCategory.maintenance;
      case 'ASSEMBLY':
        return TaskCategory.assembly;
      case 'SYSTEM_DOCUMENTATION':
        return TaskCategory.systemDocumentation;
      case 'OPTIMATION_SERVER':
        return TaskCategory.optimationServer;
      case 'DEPLOYMENT_SERVER':
        return TaskCategory.deploymentServer;
      case 'TROUBLESHOOT_SERVER':
        return TaskCategory.troubleshootServer;
      default:
        return TaskCategory.development;
    }
  }

  static TaskPriority parseTaskPriority(String priority) {
    switch (priority.toUpperCase()) {
      case 'LOW':
        return TaskPriority.low;
      case 'MEDIUM':
        return TaskPriority.medium;
      case 'HIGH':
        return TaskPriority.high;
      case 'URGENT':
        return TaskPriority.urgent;
      default:
        return TaskPriority.medium;
    }
  }

  static TaskStatus parseTaskStatus(String status) {
    switch (status.toUpperCase()) {
      case 'TODO':
        return TaskStatus.todo;
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'COMPLETED':
        return TaskStatus.completed;
      case 'BLOCKED':
        return TaskStatus.blocked;
      default:
        return TaskStatus.todo;
    }
  }

  static String taskCategoryToString(TaskCategory category) {
    switch (category) {
      case TaskCategory.riset:
        return 'RISET';
      case TaskCategory.boq:
        return 'BOQ';
      case TaskCategory.development:
        return 'DEVELOPMENT';
      case TaskCategory.implementation:
        return 'IMPLEMENTATION';
      case TaskCategory.maintenance:
        return 'MAINTENANCE';
      case TaskCategory.assembly:
        return 'ASSEMBLY';
      case TaskCategory.systemDocumentation:
        return 'SYSTEM_DOCUMENTATION';
      case TaskCategory.optimationServer:
        return 'OPTIMATION_SERVER';
      case TaskCategory.deploymentServer:
        return 'DEPLOYMENT_SERVER';
      case TaskCategory.troubleshootServer:
        return 'TROUBLESHOOT_SERVER';
    }
  }

  static String taskPriorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.urgent:
        return 'URGENT';
    }
  }

  static String taskStatusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'TODO';
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
      case TaskStatus.cancelled:
        return 'CANCELLED';
      case TaskStatus.overdue:
        return 'OVERDUE';
      case TaskStatus.onReview:
        return 'ON_REVIEW';
      case TaskStatus.onHold:
        return 'ON_HOLD';
      case TaskStatus.blocked:
        return 'BLOCKED';
    }
  }
}
