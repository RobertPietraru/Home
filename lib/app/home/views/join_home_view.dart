import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/utils/translator.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/components/buttons/long_button.dart';
import '../../../core/components/input_fields/text_input_field.dart';
import '../../../core/components/theme/app_theme.dart';
import '../blocs/join_home/join_home_cubit.dart';

class JoinHomeView extends StatelessWidget {
  const JoinHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocConsumer<JoinHomeCubit, JoinHomeState>(
      listener: (context, state) {
        if (state.isSuccessful) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: theme.standardPadding,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(height: 10),
                Text(
                  context.translator.joinHome,
                  style: theme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextInputField(
                  hint: context.translator.homeId,
                  leading: Icons.home,
                  error: state.homeIdFailure,
                  onChanged: (newId) {
                    context.read<JoinHomeCubit>().onHomeIdChanged(newId);
                  },
                ),
                const SizedBox(height: 30),
                LongButton(
                  label: context.translator.join,
                  onPressed: () async {
                    final userState = context.read<AuthBloc>().state;
                    await context
                        .read<JoinHomeCubit>()
                        .joinHome(userState.userEntity!.id, context.translator);
                  },
                  isLoading: state.status == JoinHomeStatus.loading,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
