import 'package:homeapp/core/failures/validation_failure.dart';

class TaskTitleEmptyValidationFailure extends ValidationFailure {
  const TaskTitleEmptyValidationFailure(
      {super.code = 'TaskTitleEmptyValidation'});
}
