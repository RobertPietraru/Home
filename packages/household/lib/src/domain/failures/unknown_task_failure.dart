import 'package:household/src/domain/failures/task_failure.dart';

class UnknownTaskFailure extends TaskFailure {
  const UnknownTaskFailure({super.code = 'unknown'});
}
