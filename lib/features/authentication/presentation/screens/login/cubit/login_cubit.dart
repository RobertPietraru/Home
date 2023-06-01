import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/failures/auth_failure.dart';
import '../../../../domain/usecases/login_usecase.dart';
import '../../../auth_bloc/auth_bloc.dart';
import '../../../validation/forms/email.dart';
import '../../../validation/forms/password.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;
  final AuthBloc authBloc;
  LoginCubit(this.loginUsecase, {required this.authBloc})
      : super(
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

  Future<void> login() async {
    if (state.validationFailure != null) {
      emit(state.copyWith(status: LoginStatus.error));
      return;
    }
    emit(state.copyWith(status: LoginStatus.loading));

    final response = await loginUsecase.call(
      LoginParams(email: state.email.value, password: state.password.value),
    );

    return response.fold((failure) {
      emit(state.copyWith(
        failure: failure,
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
