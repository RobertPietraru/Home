import 'package:household/src/domain/failures/task_failure.dart';

class MissingAuthenticationTaskFailure extends TaskFailure {
  const MissingAuthenticationTaskFailure({super.code = 'MissingAuthentication'});
}
