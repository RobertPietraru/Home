import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homeapp/app/auth/validation/errors/password_validation_failures.dart';
import 'package:homeapp/core/failures/validation_failure.dart';

class Password extends FormzInput<String, ValidationFailure>
    with EquatableMixin {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  ValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return const AuthPasswordEmptyValidationFailure();
    }
    return null;
  }

  @override
  List<Object?> get props => [value, isValid, error];
}
