import 'package:formz/formz.dart';
import 'package:homeapp/app/home/validation/failures/task_title_empty.dart';

import '../../../../core/failures/validation_failure.dart';

class TaskTitle extends FormzInput<String, ValidationFailure> {
  const TaskTitle.pure() : super.pure('');

  const TaskTitle.dirty([super.value = '']) : super.dirty();

  @override
  ValidationFailure? validator(String? value) {
    if ((value ?? "").isEmpty) {
      return const TaskTitleEmptyValidationFailure();
    }
    return null;
  }
}
