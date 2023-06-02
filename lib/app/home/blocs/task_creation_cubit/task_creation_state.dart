part of 'task_creation_cubit.dart';

enum TaskCreationStatus { loading, created, error, idle }

class TaskCreationState extends Equatable {
  final TaskTitle body;
  final AppFailure? error;
  final TaskCreationStatus status;
  final DateTime? deadline;
  final double importance;
  const TaskCreationState({
    this.body = const TaskTitle.pure(),
    this.error,
    this.status = TaskCreationStatus.idle,
    this.deadline,
    this.importance = 0.5,
  });

  @override
  List<Object?> get props => [body, error, status, deadline, importance];

  bool get isLoading {
    return status == TaskCreationStatus.loading;
  }

  ValidationFailure? get validationFailure {
    return body.error;
  }

  TaskCreationState copyWith({
    TaskTitle? body,
    AppFailure? failure = AppFailure.mockForDynamic,
    TaskCreationStatus? status,
    DateTime? deadline,
    double? importance,
  }) {
    return TaskCreationState(
      body: body ?? this.body,
      status: status ?? this.status,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      error: failure == AppFailure.mockForDynamic ? this.error : failure,
    );
  }
}
