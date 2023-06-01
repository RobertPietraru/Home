import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/authentication/presentation/auth_bloc/auth_bloc.dart';
import 'package:testador/features/authentication/presentation/screens/login/login_screen.dart';
import 'package:testador/features/authentication/presentation/screens/registration/cubit/registration_cubit.dart';
import 'package:testador/injection.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/components/buttons/long_button.dart';
import '../../../../../core/components/text_input_field.dart';
import '../../../../../core/components/theme/app_theme.dart';
import '../../../../../core/routing/app_router.gr.dart';

@RoutePage()
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegistrationCubit(locator(), authBloc: context.read<AuthBloc>()),
      child: _RegistrationScreen(),
    );
  }
}

class _RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translator = AppLocalizations.of(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state.isSuccessful) {
            // look, I don't know why it is this way, but it works nonetheless, so watchu gonna do?
            context.router.popUntilRoot();
            context.router.pop();
            // context.router.root.push(const ProtectedFlowRoute());
          }
        },
        builder: (context, state) {
          final theme = AppTheme.of(context);
          return Center(
            child: SizedBox(
              width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
              child: Padding(
                padding: theme.standardPadding.copyWith(bottom: 0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.translator.register,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 40,
                                color: theme.primaryColor),
                            textAlign: TextAlign.left),
                        SizedBox(height: theme.spacing.mediumLarge),
                        Text(
                          context.translator.fillInToContinue,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: theme.primaryColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: theme.spacing.xxLarge),
                        TextInputField(
                          onChanged:
                              context.read<RegistrationCubit>().onEmailChanged,
                          hint: context.translator.email,
                          error: state.emailFailure(context),
                        ),
                        SizedBox(height: theme.spacing.mediumLarge),
                        TextInputField(
                          onChanged: context
                              .read<RegistrationCubit>()
                              .onPasswordChanged,
                          hint: context.translator.password,
                          isPassword: true,
                          error: state.passwordFailure(context),
                        ),
                        SizedBox(height: theme.spacing.mediumLarge),
                        TextInputField(
                          isPassword: true,
                          onChanged: context
                              .read<RegistrationCubit>()
                              .onConfirmedPasswordChanged,
                          hint: context.translator.confirmPassword,
                          error: state.confirmPasswordFailure(context),
                        ),
                        SizedBox(height: theme.spacing.xxLarge),
                        LongButton(
                          onPressed: () =>
                              context.read<RegistrationCubit>().register(),
                          label: context.translator.register,
                          isLoading: state.isLoading,
                        ),
                        SizedBox(height: theme.spacing.xxLarge),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                if (DeviceSize.isDesktopMode) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const LoginDialog(),
                                  );
                                } else {
                                  context.router.replace(const LoginRoute());
                                }
                              },
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        context.translator.alreadyHaveAnAccount,
                                    style: theme.actionTextStyle
                                        .copyWith(color: theme.primaryColor),
                                  ),
                                  TextSpan(
                                      text: ' ${translator.login}',
                                      style: theme.actionTextStyle
                                          .copyWith(color: theme.companyColor)),
                                ]),
                              )),
                        )
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
