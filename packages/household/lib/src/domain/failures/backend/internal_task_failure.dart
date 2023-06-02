import 'package:household/src/domain/failures/task_failure.dart';

class InternalTaskFailure extends TaskFailure {
  const InternalTaskFailure({super.code = 'Internal'});
}
