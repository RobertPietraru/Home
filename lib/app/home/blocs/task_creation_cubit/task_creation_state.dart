part of 'task_creation_cubit.dart';

enum TaskCreationStatus { loading, created, error, idle }

class TaskCreationState extends Equatable {
  final TaskTitle body;
  final AppFailure? failure;
  final TaskCreationStatus status;
  final DateTime? deadline;
  final double importance;
  const TaskCreationState({
    this.body = const TaskTitle.pure(),
    this.failure,
    this.status = TaskCreationStatus.idle,
    this.deadline,
    this.importance = 0.5,
  });

  @override
  List<Object?> get props => [body, failure, status, deadline, importance];

  bool get isLoading {
    return status == TaskCreationStatus.loading;
  }

  ValidationFailure? get validationFailure {
    return body.error;
  }

  String? get titleError =>
      failure?.fieldWithIssue == FieldWithIssue.taskCreationTitle
          ? failure?.message
          : null;
  List<FieldWithIssue> get _fields => [FieldWithIssue.taskCreationTitle];

  String? get fieldlessError => failure == null
      ? null
      : _fields.contains(failure!.fieldWithIssue)
          ? null
          : failure!.message;

  TaskCreationState copyWith({
    TaskTitle? body,
    AppFailure? failure = AppFailure.mock,
    TaskCreationStatus? status,
    DateTime? deadline,
    double? importance,
  }) {
    return TaskCreationState(
      body: body ?? this.body,
      status: status ?? this.status,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      failure: failure == AppFailure.mock ? this.failure : failure,
    );
  }
}
