import 'package:household/src/domain/failures/task_failure.dart';

class AbortedTaskFailure extends TaskFailure {
  const AbortedTaskFailure({super.code = 'aborted'});
}
