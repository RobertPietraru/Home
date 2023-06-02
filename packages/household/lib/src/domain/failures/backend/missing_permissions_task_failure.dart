import 'package:household/src/domain/failures/task_failure.dart';

class MissingPermissionsTaskFailure extends TaskFailure {
  const MissingPermissionsTaskFailure({super.code = 'MissingPermissions'});
}
