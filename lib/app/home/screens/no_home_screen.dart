import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/homes_cubit/homes_cubit.dart';
import 'package:homeapp/core/components/buttons/long_button.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:homeapp/core/utils/translator.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../injection.dart';
import '../blocs/join_home/join_home_cubit.dart';
import '../views/join_home_view.dart';
import 'create_home_screen.dart';

class NoHomeScreen extends StatelessWidget {
  const NoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthUserLoggedOut());
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: theme.standardPadding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Center(
                child: Text(
                  context.translator.youDontHaveAHome,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  LongButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<HomesCubit>(context),
                              child: const CreateHomeScreen(),
                            ),
                          ));
                    },
                    label: context.translator.create,
                    isLoading: false,
                    color: theme.companyColor,
                  ),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (modalContext) {
                            return BlocProvider(
                              create: (_) => JoinHomeCubit(locator(),
                                  homesCubit: context.read<HomesCubit>()),
                              child: const JoinHomeView(),
                            );
                          },
                        );
                      },
                      child: Text(
                        context.translator.join,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                      )),
                ],
              ),
            ]),
      ),
    );
  }
}
