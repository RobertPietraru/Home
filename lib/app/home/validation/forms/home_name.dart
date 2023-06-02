import 'package:formz/formz.dart';
import 'package:homeapp/core/failures/validation_failure.dart';

import '../failures/home_name_empty_validation_failure.dart';

/// Validation errors for the [HomeName] [FormzInput].

/// {@template HomeName}
/// Form input for an HomeName input.
/// {@endtemplate}
class HomeName extends FormzInput<String, ValidationFailure> {
  /// {@macro HomeName}
  const HomeName.pure() : super.pure('');

  /// {@macro HomeName}
  const HomeName.dirty([super.value = '']) : super.dirty();

  // static final RegExp _homeNameRegExp = RegExp(
  //   r'',
  // );

  @override
  ValidationFailure? validator(String? value) {
    // return _homeNameRegExp.hasMatch(value ?? '')
    //     ? null
    //     : HomeNameEmptyValidationFailure.invalid;
    if ((value ?? "").isEmpty) {
      return const HomeNameEmptyValidationFailure();
    }
    return null;
  }
}
