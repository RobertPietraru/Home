import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/failures/app_failure.dart';
import 'package:homeapp/core/failures/validation_failure.dart';
import 'package:homeapp/core/utils/translator.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../validation/forms/email.dart';
import '../../validation/forms/password.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  // final Translator translator;
  LoginCubit(
    this.authRepository, {
    required this.authBloc,
  }) : super(
            const LoginState(email: Email.dirty(), password: Password.dirty()));
  void onEmailChanged(String email) {
    final newEmail = Email.dirty(email);
    emit(state.copyWith(
        email: newEmail, status: LoginStatus.init, failure: null));
  }

  void onPasswordChanged(String password) {
    final newPassword = Password.dirty(password);
    emit(state.copyWith(
        password: newPassword, status: LoginStatus.init, failure: null));
  }

  Future<void> login(BuildContext context) async {
    if (state.validationFailure != null) {
      emit(state.copyWith(
          status: LoginStatus.error,
          failure: AppFailure.fromValidationFailure(
              state.validationFailure!, context.translator)));
      return;
    }
    emit(state.copyWith(status: LoginStatus.loading));

    final response = await authRepository.logUserIn(
        LoginParams(email: state.email.value, password: state.password.value));

    return response.fold((failure) {
      emit(state.copyWith(
        failure: AppFailure.fromAuthFailure(failure, context.translator),
        status: LoginStatus.error,
      ));
    }, (user) {
      authBloc.add(AuthUserLoggedIn(entity: user));

      emit(state.copyWith(
        status: LoginStatus.successful,
      ));
    });
  }
}
