import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/components/theme/device_size.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:homeapp/injection.dart';

import '../../../../../core/components/buttons/long_button.dart';
import '../../../core/components/input_fields/text_input_field.dart';
import '../../../../../core/components/theme/app_theme.dart';
import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../login/login_screen.dart';
import 'cubit/registration_cubit.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationCubit(
        locator(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: _RegistrationScreen(),
    );
  }
}

class _RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Builder(builder: (context) {
        return BlocConsumer<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.isSuccessful) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          builder: (context, state) {
            final theme = AppTheme.of(context);
            return Center(
              child: SizedBox(
                width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
                child: Padding(
                  padding: theme.standardPadding
                      .copyWith(bottom: theme.spacing.xxLarge),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.translator.register,
                            style: theme.largetitleTextStyle,
                            textAlign: TextAlign.left),
                        Text(
                          context.translator.fillInToContinue,
                          style: theme.informationTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Column(
                          children: [
                            TextInputField(
                              onChanged: context
                                  .read<RegistrationCubit>()
                                  .onEmailChanged,
                              hint: context.translator.email,
                              error: state.emailFailure(context),
                            ),
                            SizedBox(height: theme.spacing.medium),
                            TextInputField(
                              onChanged: context
                                  .read<RegistrationCubit>()
                                  .onPasswordChanged,
                              hint: context.translator.password,
                              isPassword: true,
                              error: state.passwordFailure(context),
                            ),
                            SizedBox(height: theme.spacing.medium),
                            TextInputField(
                              isPassword: true,
                              onChanged: context
                                  .read<RegistrationCubit>()
                                  .onConfirmedPasswordChanged,
                              hint: context.translator.confirmPassword,
                              error: state.confirmPasswordFailure(context),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            LongButton(
                              onPressed: () => context
                                  .read<RegistrationCubit>()
                                  .register(context),
                              label: context.translator.register,
                              color: theme.companyColor,
                              isLoading: state.isLoading,
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen())),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: context
                                            .translator.alreadyHaveAnAccount,
                                        style: theme.actionTextStyle.copyWith(
                                            color: theme.primaryColor),
                                      ),
                                      TextSpan(
                                          text: ' ${context.translator.login}',
                                          style: theme.actionTextStyle.copyWith(
                                              color: theme.companyColor)),
                                    ]),
                                  )),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
