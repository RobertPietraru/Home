import 'package:formz/formz.dart';
import 'package:homeapp/app/home/validation/failures/home_id_empty_validation_failure.dart';

import '../../../../core/failures/validation_failure.dart';

class HomeId extends FormzInput<String, ValidationFailure> {
  const HomeId.pure() : super.pure('');

  const HomeId.dirty([super.value = '']) : super.dirty();

  @override
  ValidationFailure? validator(String? value) {
    // return _HomeIdRegExp.hasMatch(value ?? '')
    //     ? null
    //     : ValidationFailure.invalid;
    if ((value ?? "").isEmpty) {
      return const HomeIdEmptyValidationFailure();
    }
    return null;
  }
}
