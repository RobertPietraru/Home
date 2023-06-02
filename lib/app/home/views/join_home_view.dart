import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/core/presentation/widgets/buttons/long_button.dart';
import 'package:pietrocka_home/core/presentation/widgets/inputfields/text_input_field.dart';
import 'package:pietrocka_home/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/join_home/join_home_cubit.dart';

import '../../../../core/global/styles.dart';

class JoinHomeView extends StatelessWidget {
  const JoinHomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(8.0),
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
                      color: Styles.secondaryColor,
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Join Home",
                  style: Styles.titleStyle1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextInputField(
                  hint: "Home id",
                  prefixIcon: Icons.home,
                  error: state.errorMessage,
                  onChanged: (newId) {
                    context.read<JoinHomeCubit>().onHomeIdChanged(newId);
                  },
                ),
                const SizedBox(height: 30),
                LongButton(
                    text: "Join",
                    onPressed: context.read<AuthBloc>().state.isAuthenticated
                        ? () async {
                            final userState = context.read<AuthBloc>().state;
                            await context
                                .read<JoinHomeCubit>()
                                .joinHome(userState.userId!);
                          }
                        : null),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
