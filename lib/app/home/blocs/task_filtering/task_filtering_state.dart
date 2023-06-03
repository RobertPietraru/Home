part of 'task_filtering_cubit.dart';

enum FilterSortTarget { creationDate, deadline, importance }

class TaskFilteringState extends Equatable {
  final List<FilterSortTarget> sortByFields;
  final UserEntity? selectedAsignee;
  final bool showCompletedTasks;

  const TaskFilteringState({
    required this.sortByFields,
    this.selectedAsignee,
    required this.showCompletedTasks,
  });

  factory TaskFilteringState.initial() {
    return const TaskFilteringState(
      sortByFields: [],
      showCompletedTasks: false,
      selectedAsignee: null,
    );
  }

  bool get canReset => TaskFilteringState.initial() != this;

  TaskFilteringState copyWith({
    List<FilterSortTarget>? sortByFields,
    UserEntity? selectedAsignee = UserEntity.mock,
    bool? showCompletedTasks,
  }) {
    return TaskFilteringState(
      sortByFields: sortByFields ?? this.sortByFields,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
      selectedAsignee: selectedAsignee == UserEntity.mock
          ? this.selectedAsignee
          : selectedAsignee,
    );
  }

  @override
  List<Object?> get props =>
      [showCompletedTasks, selectedAsignee, ...sortByFields];
}
