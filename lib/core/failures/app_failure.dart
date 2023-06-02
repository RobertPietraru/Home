import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:homeapp/app/home/validation/failures/home_id_empty_validation_failure.dart';
import 'package:homeapp/app/home/validation/failures/home_name_empty_validation_failure.dart';
import 'package:homeapp/core/failures/validation_failure.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../app/auth/validation/errors/confirm_password_validation_failures.dart';
import '../../app/auth/validation/errors/email_validation_failures.dart';
import '../../app/auth/validation/errors/password_validation_failures.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class AppFailure<T> extends Equatable {
  final String code;
  final T? fieldWithIssue;
  final String message;

  const AppFailure(
      {this.fieldWithIssue, required this.code, required this.message});

  static AppFailure<AuthFieldWithIssue> fromAuthFailure(
      AuthFailure failure, Translator translator) {
    final errors = {
      DisabledUserFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.disabledUserError,
          fieldWithIssue: AuthFieldWithIssue.email),
      EmailAlreadyExistsFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.emailAlreadyExistsError,
          fieldWithIssue: AuthFieldWithIssue.email),
      InvalidEmailFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.invalidEmailError,
          fieldWithIssue: AuthFieldWithIssue.email),
      UserNotFoundFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.userNotFoundError,
          fieldWithIssue: AuthFieldWithIssue.email),
      WrongAuthenticationMethodFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.wrongAuthenticationMethodError,
          fieldWithIssue: AuthFieldWithIssue.other),
      InvalidCredentialsFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.invalidCredentialsError,
          fieldWithIssue: AuthFieldWithIssue.other),
      InvalidVerificationCodeFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.invalidVerificationCodeError,
          fieldWithIssue: AuthFieldWithIssue.other),
      MissingAuthenticationFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.missingAuthenticationError,
          fieldWithIssue: AuthFieldWithIssue.other),
      MissingPermissionFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.missingPermissionError,
          fieldWithIssue: AuthFieldWithIssue.other),
      NetworkAuthFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.networkError,
          fieldWithIssue: AuthFieldWithIssue.other),
      UnknownAuthFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: AuthFieldWithIssue.other),
      InvalidPasswordFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.invalidPasswordError,
          fieldWithIssue: AuthFieldWithIssue.password),
      WeakPasswordFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.weakPasswordError,
          fieldWithIssue: AuthFieldWithIssue.password),
      WrongPasswordFailure: AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.wrongPasswordError,
          fieldWithIssue: AuthFieldWithIssue.password),
    };
    return errors[failure.runtimeType] ??
        AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: AuthFieldWithIssue.other,
        );
  }

  static AppFailure<AuthFieldWithIssue> fromAuthValidationFailure(
      ValidationFailure failure, Translator translator) {
    final x = {
      AuthConfirmPasswordEmptyValidationFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.confirmPasswordEmptyValidationError,
        fieldWithIssue: AuthFieldWithIssue.confirmedPassword,
      ),
      AuthConfirmPasswordMatchFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.confirmPasswordMatchError,
        fieldWithIssue: AuthFieldWithIssue.confirmedPassword,
      ),
      AuthEmailEmptyValidationFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.emailEmptyValidationError,
        fieldWithIssue: AuthFieldWithIssue.email,
      ),
      AuthEmailInvalidFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.invalidEmailError,
        fieldWithIssue: AuthFieldWithIssue.email,
      ),
      AuthPasswordEmptyValidationFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.passwordEmptyValidationError,
        fieldWithIssue: AuthFieldWithIssue.password,
      ),
      AuthPasswordInvalidFailure: AppFailure<AuthFieldWithIssue>(
        code: failure.code,
        message: translator.invalidPasswordError,
        fieldWithIssue: AuthFieldWithIssue.password,
      ),
    };
    return x[failure.runtimeType] ??
        AppFailure<AuthFieldWithIssue>(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: AuthFieldWithIssue.other,
        );
  }

  static AppFailure fromTaskFailure(
      TaskFailure failure, Translator translator) {
    final x = {
      UnknownTaskFailure: AppFailure(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: null),
      TaskNotFoundTaskFailure: AppFailure(
          code: failure.code,
          message: translator.taskNotFoundTaskError,
          fieldWithIssue: null),
      MissingPermissionsTaskFailure: AppFailure(
          code: failure.code,
          message: translator.missingPermissionError,
          fieldWithIssue: null),
      MissingAuthenticationTaskFailure: AppFailure(
          code: failure.code,
          message: translator.missingAuthenticationError,
          fieldWithIssue: null),
      InvalidInputTaskFailure: AppFailure(
          code: failure.code,
          message: translator.invalidInputTaskError,
          fieldWithIssue: null),
      InternalTaskFailure: AppFailure(
          code: failure.code,
          message: translator.internalTaskError,
          fieldWithIssue: null),
      HomeNotFoundTaskFailure: AppFailure(
          code: failure.code,
          message: translator.homeNotFoundTaskError,
          fieldWithIssue: null),
      AbortedTaskFailure: AppFailure(
          code: failure.code,
          message: translator.abortedTaskError,
          fieldWithIssue: null),
    };
    return x[failure.runtimeType] ??
        AppFailure(
          code: failure.code,
          message: translator.thereWasAnError,
        );
  }

  static const AppFailure<AuthFieldWithIssue> mockForAuth =
      AppFailure<AuthFieldWithIssue>(code: 'mock', message: '');
  static const AppFailure mockForDynamic =
      AppFailure(code: 'mock', message: '');

  @override
  List<Object?> get props => [code, fieldWithIssue];

  static AppFailure fromTaskValidationFailure(
      ValidationFailure validationFailure, Translator translator) {
    final errors = {
      HomeIdEmptyValidationFailure: AppFailure(
          code: validationFailure.code,
          message: translator.homeIdEmptyValidationError),
      HomeNameEmptyValidationFailure: AppFailure(
          code: validationFailure.code,
          message: translator.homeNameEmptyValidationError)
    };
    return errors[validationFailure.runtimeType] ?? unknown(translator);
  }

  static AppFailure<G> unknown<G>(Translator translator) =>
      AppFailure<G>(code: 'unknown', message: translator.thereWasAnError);
}
