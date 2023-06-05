part of 'task_filtering_cubit.dart';

class TaskFilteringState extends Equatable {
  final List<TaskSortFilter> sortFilters;
  final UserEntity? selectedAsignee;
  final bool showCompletedTasks;

  final TaskFilteringState? lastUsedState;

  const TaskFilteringState({
    this.lastUsedState,
    required this.sortFilters,
    this.selectedAsignee,
    required this.showCompletedTasks,
  });

  factory TaskFilteringState.initial() {
    return const TaskFilteringState(
      sortFilters: [],
      showCompletedTasks: false,
      selectedAsignee: null,
      lastUsedState: null,
    );
  }

  TaskFilters get filter {
    return TaskFilters(
      sortFilters: sortFilters,
      showCompletedTasks: showCompletedTasks,
      assigneeId: selectedAsignee?.id,
    );
  }

  bool get canReset => TaskFilteringState.initial() != this;
  bool get isFiltered => TaskFilteringState.initial() != this;

  TaskFilteringState copyWith({
    List<TaskSortFilter>? sortFilters,
    UserEntity? selectedAsignee = UserEntity.mock,
    bool? showCompletedTasks,
    TaskFilteringState? lastUsedState,
  }) {
    return TaskFilteringState(
      lastUsedState: lastUsedState ?? this.lastUsedState,
      sortFilters: sortFilters ?? this.sortFilters,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
      selectedAsignee: selectedAsignee == UserEntity.mock
          ? this.selectedAsignee
          : selectedAsignee,
    );
  }

  @override
  List<Object?> get props =>
      [showCompletedTasks, selectedAsignee, ...sortFilters];
}
