import 'package:equatable/equatable.dart';

export 'backend/aborted_task_failure.dart';
export 'backend/home_not_found.dart';
export 'backend/internal_task_failure.dart';
export 'backend/invalid_input_task_failure.dart';
export 'backend/missing_authentication_task_failure.dart';
export 'backend/missing_permissions_task_failure.dart';
export 'backend/task_not_found_task_failure.dart';
export 'unknown_task_failure.dart';

abstract class TaskFailure extends Equatable {
  final String code;
  const TaskFailure({required this.code});

  @override
  List<Object?> get props => [code];
}
