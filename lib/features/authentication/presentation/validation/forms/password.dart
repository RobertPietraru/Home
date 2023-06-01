import 'package:equatable/equatable.dart';

import 'package:formz/formz.dart';
import 'package:homeapp/features/authentication/presentation/validation/errors/password_validation_failures.dart';

import '../../../../../../packages/auth/lib/domain/failures/auth_failure.dart';

class Password extends FormzInput<String, AuthValidationFailure>
    with EquatableMixin {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  // static final _passwordRegExp =
  //     RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  AuthValidationFailure? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return AuthPasswordEmptyValidationFailure();
    }
    return null;
    // return _passwordRegExp.hasMatch(value ?? '')
    //     ? null
    //     : PasswordValidationError.invalid;
  }

  @override
  List<Object?> get props => [value, isValid, error];
}
