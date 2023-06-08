import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:homeapp/app/home/validation/failures/home_id_empty_validation_failure.dart';
import 'package:homeapp/app/home/validation/failures/home_name_empty_validation_failure.dart';
import 'package:homeapp/app/home/validation/failures/task_title_empty.dart';
import 'package:homeapp/core/failures/validation_failure.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';

import '../../app/auth/validation/errors/confirm_password_validation_failures.dart';
import '../../app/auth/validation/errors/email_validation_failures.dart';
import '../../app/auth/validation/errors/password_validation_failures.dart';

enum FieldWithIssue {
  // authFlow
  authEmail,
  authPassword,
  authConfirmationPassword,
  // home
  homeName,
  homeId,

  // taskCreation
  taskCreationTitle,
}

class AppFailure extends Equatable {
  final String code;
  final FieldWithIssue? fieldWithIssue;
  final String message;

  const AppFailure(
      {this.fieldWithIssue, required this.code, required this.message});

  factory AppFailure.fromAuthFailure(
      AuthFailure failure, Translator translator) {
    final errors = {
      DisabledUserFailure: AppFailure(
          code: failure.code,
          message: translator.disabledUserError,
          fieldWithIssue: FieldWithIssue.authEmail),
      EmailAlreadyExistsFailure: AppFailure(
          code: failure.code,
          message: translator.emailAlreadyExistsError,
          fieldWithIssue: FieldWithIssue.authEmail),
      InvalidEmailFailure: AppFailure(
          code: failure.code,
          message: translator.invalidEmailError,
          fieldWithIssue: FieldWithIssue.authEmail),
      UserNotFoundFailure: AppFailure(
          code: failure.code,
          message: translator.userNotFoundError,
          fieldWithIssue: FieldWithIssue.authEmail),
      WrongAuthenticationMethodFailure: AppFailure(
          code: failure.code,
          message: translator.wrongAuthenticationMethodError,
          fieldWithIssue: null),
      InvalidCredentialsFailure: AppFailure(
          code: failure.code,
          message: translator.invalidCredentialsError,
          fieldWithIssue: null),
      InvalidVerificationCodeFailure: AppFailure(
          code: failure.code,
          message: translator.invalidVerificationCodeError,
          fieldWithIssue: null),
      MissingAuthenticationFailure: AppFailure(
          code: failure.code,
          message: translator.missingAuthenticationError,
          fieldWithIssue: null),
      MissingPermissionFailure: AppFailure(
          code: failure.code,
          message: translator.missingPermissionError,
          fieldWithIssue: null),
      NetworkAuthFailure: AppFailure(
          code: failure.code,
          message: translator.networkError,
          fieldWithIssue: null),
      UnknownAuthFailure: AppFailure(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: null),
      InvalidPasswordFailure: AppFailure(
          code: failure.code,
          message: translator.invalidPasswordError,
          fieldWithIssue: FieldWithIssue.authPassword),
      WeakPasswordFailure: AppFailure(
          code: failure.code,
          message: translator.weakPasswordError,
          fieldWithIssue: FieldWithIssue.authPassword),
      WrongPasswordFailure: AppFailure(
          code: failure.code,
          message: translator.wrongPasswordError,
          fieldWithIssue: FieldWithIssue.authPassword),
    };
    return errors[failure.runtimeType] ??
        AppFailure(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: null,
        );
  }

  factory AppFailure.fromValidationFailure(
      ValidationFailure failure, Translator translator) {
    final x = {
      AuthConfirmPasswordEmptyValidationFailure: AppFailure(
        code: failure.code,
        message: translator.confirmPasswordEmptyValidationError,
        fieldWithIssue: FieldWithIssue.authConfirmationPassword,
      ),
      AuthConfirmPasswordMatchFailure: AppFailure(
        code: failure.code,
        message: translator.confirmPasswordMatchError,
        fieldWithIssue: FieldWithIssue.authConfirmationPassword,
      ),
      AuthEmailEmptyValidationFailure: AppFailure(
        code: failure.code,
        message: translator.emailEmptyValidationError,
        fieldWithIssue: FieldWithIssue.authEmail,
      ),
      AuthEmailInvalidFailure: AppFailure(
        code: failure.code,
        message: translator.invalidEmailError,
        fieldWithIssue: FieldWithIssue.authEmail,
      ),
      AuthPasswordEmptyValidationFailure: AppFailure(
        code: failure.code,
        message: translator.passwordEmptyValidationError,
        fieldWithIssue: FieldWithIssue.authPassword,
      ),
      AuthPasswordInvalidFailure: AppFailure(
        code: failure.code,
        message: translator.invalidPasswordError,
        fieldWithIssue: FieldWithIssue.authPassword,
      ),
      HomeIdEmptyValidationFailure: AppFailure(
          code: failure.code,
          fieldWithIssue: FieldWithIssue.homeId,
          message: translator.homeIdEmptyValidationError),
      HomeNameEmptyValidationFailure: AppFailure(
          code: failure.code,
          fieldWithIssue: FieldWithIssue.homeName,
          message: translator.homeNameEmptyValidationError),
      TaskTitleEmptyValidationFailure: AppFailure(
        code: failure.code,
        message: translator.provideTaskTitle,
        fieldWithIssue: FieldWithIssue.taskCreationTitle,
      )
    };
    return x[failure.runtimeType] ??
        AppFailure(
          code: failure.code,
          message: translator.thereWasAnError,
          fieldWithIssue: null,
        );
  }

  factory AppFailure.fromTaskFailure(
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
    return x[failure.runtimeType] ?? unknown(translator);
  }

  static const AppFailure mock = AppFailure(code: 'mock', message: '');

  @override
  List<Object?> get props => [code, fieldWithIssue];

  static AppFailure unknown(Translator translator) =>
      AppFailure(code: 'unknown', message: translator.thereWasAnError);
}
