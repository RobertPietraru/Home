import 'package:household/src/domain/failures/task_failure.dart';

class TaskNotFoundTaskFailure extends TaskFailure {
  const TaskNotFoundTaskFailure({super.code = 'TaskNotFound'});
}
