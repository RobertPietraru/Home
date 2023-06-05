part of 'tasks_cubit.dart';

enum TasksStatus { initial, loading, loaded, error }

class TasksState extends Equatable {
  final List<TaskEntity> tasks;
  final TasksStatus status;
  final AppFailure? error;
  final TaskFilters filters;
  const TasksState({
    required this.filters,
    required this.tasks,
    this.status = TasksStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [...tasks, status, error, filters];

  TasksState copyWith({
    List<TaskEntity>? tasks,
    TasksStatus? status,
    AppFailure? error = AppFailure.mock,
    TaskFilters? filters,
  }) {
    return TasksState(
      filters: filters ?? this.filters,
      tasks: tasks ?? this.tasks,
      error: error == AppFailure.mock ? this.error : error,
      status: status ?? this.status,
    );
  }
}
