import 'package:household/src/domain/failures/task_failure.dart';

class InvalidInputTaskFailure extends TaskFailure {
  const InvalidInputTaskFailure({super.code = 'InvalidInput'});
}
