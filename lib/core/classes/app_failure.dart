import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:homeapp/app/auth/auth_bloc/auth_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';

class AppFailure<T> extends Equatable {
  final String code;
  final T? fieldWithIssue;
  final String message;

  const AppFailure(
      {this.fieldWithIssue, required this.code, required this.message});

  static AppFailure<AuthFieldWithIssue> fromAuthFailure(
      AuthFailure failure, Translator translator) {
    return AppFailure<AuthFieldWithIssue>(
      code: failure.code,
      message: translator.thereWasAnError,
      fieldWithIssue: AuthFieldWithIssue.other,
    );
  }

  static const AppFailure<AuthFieldWithIssue> mockForAuth =
      AppFailure<AuthFieldWithIssue>(code: 'mock', message: '');

  @override
  List<Object?> get props => [code, fieldWithIssue];
}
