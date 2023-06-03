part of 'tasks_cubit.dart';

enum TasksStatus { initial, loading, loaded, error }

class TasksState extends Equatable {
  final List<TaskEntity> chores;
  final List<TaskEntity> shoppingList;
  final TasksStatus status;
  final AppFailure? error;
  const TasksState({
    required this.chores,
    required this.shoppingList,
    this.status = TasksStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [chores, shoppingList, status, error];

  TasksState copyWith({
    List<TaskEntity>? chores,
    List<TaskEntity>? shoppingList,
    TasksStatus? status,
    AppFailure? error = AppFailure.mock,
  }) {
    return TasksState(
      chores: chores ?? this.chores,
      shoppingList: shoppingList ?? this.shoppingList,
      error: error == AppFailure.mock ? this.error : error,
      status: status ?? this.status,
    );
  }
}
