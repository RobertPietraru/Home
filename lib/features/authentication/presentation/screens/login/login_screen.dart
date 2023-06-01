import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/buttons/long_button.dart';
import 'package:testador/core/components/text_input_field.dart';
import 'package:testador/core/components/theme/app_theme.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/authentication/domain/failures/auth_failure.dart';
import 'package:testador/features/authentication/presentation/auth_bloc/auth_bloc.dart';
import 'package:testador/features/authentication/presentation/screens/login/cubit/login_cubit.dart';
import 'package:testador/injection.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/routing/app_router.gr.dart';

@RoutePage(name: 'LoginDialogRoute')
class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(locator(), authBloc: context.read<AuthBloc>()),
      child: CustomDialog(
        child: _LoginBlocWrapper(child: _LoginView()),
      ),
    );
  }
}

@RoutePage()
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
      padding: theme.standardPadding,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccessful) {
            // look, I don't know why it is this way, but it works nonetheless, so watchu gonna do?
            context.router.popUntilRoot();
            context.router.pop();
          }
        },
        builder: (context, state) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.translator.login, style: theme.titleTextStyle),
                SizedBox(height: theme.spacing.mediumLarge),
                Text(
                  context.translator.completeToContinue,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: theme.spacing.xxLarge),
                TextInputField(
                  onChanged: context.read<LoginCubit>().onEmailChanged,
                  hint: context.translator.email,
                  error: state.emailFailure(context),
                ),
                SizedBox(height: theme.spacing.mediumLarge),
                TextInputField(
                  onChanged: context.read<LoginCubit>().onPasswordChanged,
                  hint: context.translator.password,
                  isPassword: true,
                  error: state.passwordFailure(context),
                ),
                SizedBox(height: theme.spacing.mediumLarge),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: null,
                      child: Text(context.translator.forgotYourPassword))
                ]),
                SizedBox(height: theme.spacing.mediumLarge),
                LongButton(
                    onPressed: () => context.read<LoginCubit>().login(),
                    label: context.translator.login,
                    error: state.failure?.fieldWithIssue == FieldWithIssue.none
                        ? state.failure?.retrieveMessage(context)
                        : null,
                    isLoading: state.isLoading),
                SizedBox(height: theme.spacing.xxLarge),
                Center(
                  child: TextButton(
                      onPressed: () =>
                          context.router.replace(const RegistrationRoute()),
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
                )
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
