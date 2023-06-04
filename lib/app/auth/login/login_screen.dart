import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/components/buttons/long_button.dart';
import 'package:homeapp/core/components/input_fields/text_input_field.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:homeapp/injection.dart';
import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(locator(), authBloc: context.read<AuthBloc>()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: _LoginBlocWrapper(child: _LoginView()),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: theme.standardPadding.copyWith(bottom: theme.spacing.xxLarge),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccessful) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        builder: (context, state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.translator.login,
                    style: theme.largetitleTextStyle),
                Text(
                  context.translator.fillInToContinue,
                  style: theme.informationTextStyle,
                  textAlign: TextAlign.left,
                ),
                Column(
                  children: [
                    TextInputField(
                      onChanged: context.read<LoginCubit>().onEmailChanged,
                      hint: context.translator.email,
                      error: state.emailFailure(context),
                    ),
                    SizedBox(height: theme.spacing.medium),
                    TextInputField(
                      onChanged: context.read<LoginCubit>().onPasswordChanged,
                      hint: context.translator.password,
                      isPassword: true,
                      error: state.passwordFailure(context),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.xxxLarge),
                Column(
                  children: [
                    LongButton(
                        onPressed: () =>
                            context.read<LoginCubit>().login(context),
                        label: context.translator.login,
                        color: theme.companyColor,
                        error: state.failure?.fieldWithIssue == null
                            ? state.failure?.message
                            : null,
                        isLoading: state.isLoading),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: context.translator.dontHaveAnAccount,
                                style: theme.actionTextStyle
                                    .copyWith(color: theme.primaryColor),
                              ),
                              TextSpan(
                                  text: ' ${context.translator.register}',
                                  style: theme.actionTextStyle.copyWith(
                                    color: theme.companyColor,
                                  )),
                            ]),
                          )),
                    ),
                  ],
                ),
              ]);
        },
      ),
    );
  }
}

class _LoginBlocWrapper extends StatelessWidget {
  final Widget child;
  const _LoginBlocWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(locator(), authBloc: context.read<AuthBloc>()),
      child: child,
    );
  }
}
