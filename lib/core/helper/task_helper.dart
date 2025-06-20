import 'package:expense_tracker/app/data/models/pagination_model.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:get/get.dart';

mixin TaskHelpers {
  final RxBool isTodoLoading = false.obs;
  final RxBool isInProgressLoading = false.obs;
  final RxBool isCompletedLoading = false.obs;
  final RxBool isBlockedLoading = false.obs;

  final RxBool isTodoPaginationLoading = false.obs;
  final RxBool isInProgressPaginationLoading = false.obs;
  final RxBool isCompletedPaginationLoading = false.obs;
  final RxBool isBlockedPaginationLoading = false.obs;

  final RxString todoError = ''.obs;
  final RxString inProgressError = ''.obs;
  final RxString completedError = ''.obs;
  final RxString blockedError = ''.obs;

  final Rxn<Pagination> todoPagination = Rxn<Pagination>();
  final Rxn<Pagination> inProgressPagination = Rxn<Pagination>();
  final Rxn<Pagination> completedPagination = Rxn<Pagination>();
  final Rxn<Pagination> blockedPagination = Rxn<Pagination>();

  void setLoadingState(TaskStatus status, bool loading) {
    switch (status) {
      case TaskStatus.todo:
        isTodoLoading.value = loading;
        break;
      case TaskStatus.inProgress:
        isInProgressLoading.value = loading;
        break;
      case TaskStatus.completed:
        isCompletedLoading.value = loading;
        break;
      case TaskStatus.blocked:
        isBlockedLoading.value = loading;
        break;
      default:
        break;
    }
  }

  void setPaginationLoadingState(TaskStatus status, bool loading) {
    switch (status) {
      case TaskStatus.todo:
        isTodoPaginationLoading.value = loading;
        break;
      case TaskStatus.inProgress:
        isInProgressPaginationLoading.value = loading;
        break;
      case TaskStatus.completed:
        isCompletedPaginationLoading.value = loading;
        break;
      case TaskStatus.blocked:
        isBlockedPaginationLoading.value = loading;
        break;
      default:
        break;
    }
  }

  void setErrorMessage(TaskStatus status, String message) {
    switch (status) {
      case TaskStatus.todo:
        todoError.value = message;
        break;
      case TaskStatus.inProgress:
        inProgressError.value = message;
        break;
      case TaskStatus.completed:
        completedError.value = message;
        break;
      case TaskStatus.blocked:
        blockedError.value = message;
        break;
      default:
        break;
    }
  }

  void updatePagination(TaskStatus status, Pagination pagination) {
    switch (status) {
      case TaskStatus.todo:
        todoPagination.value = pagination;
        break;
      case TaskStatus.inProgress:
        inProgressPagination.value = pagination;
        break;
      case TaskStatus.completed:
        completedPagination.value = pagination;
        break;
      case TaskStatus.blocked:
        blockedPagination.value = pagination;
        break;
      default:
        break;
    }
  }

  Pagination? getPagination(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return todoPagination.value;
      case TaskStatus.inProgress:
        return inProgressPagination.value;
      case TaskStatus.completed:
        return completedPagination.value;
      case TaskStatus.blocked:
        return blockedPagination.value;
      default:
        return null;
    }
  }

  bool hasNextPage(Pagination? pagination) {
    if (pagination == null) return false;
    return (pagination.page ?? 0) < (pagination.totalPages ?? 0);
  }

  bool canLoadMore(TaskStatus status) {
    final pagination = getPagination(status);
    if (pagination == null) return false;
    switch (status) {
      case TaskStatus.todo:
        return hasNextPage(pagination) && !isTodoPaginationLoading.value;
      case TaskStatus.inProgress:
        return hasNextPage(pagination) && !isInProgressPaginationLoading.value;
      case TaskStatus.completed:
        return hasNextPage(pagination) && !isCompletedPaginationLoading.value;
      case TaskStatus.blocked:
        return hasNextPage(pagination) && !isBlockedPaginationLoading.value;
      default:
        return false;
    }
  }

  bool canLoadMoreTodo() {
    final pagination = todoPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isTodoPaginationLoading.value;
  }

  bool canLoadMoreInProgress() {
    final pagination = inProgressPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isInProgressPaginationLoading.value;
  }

  bool canLoadMoreCompleted() {
    final pagination = completedPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isCompletedPaginationLoading.value;
  }

  bool canLoadMoreBlocked() {
    final pagination = blockedPagination.value;
    return pagination != null &&
        _hasNextPage(pagination) &&
        !isBlockedPaginationLoading.value;
  }

  bool _hasNextPage(Pagination pagination) {
    return (pagination.page ?? 0) < (pagination.totalPages ?? 0);
  }
}
