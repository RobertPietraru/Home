import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/app/home/blocs/cubit/homes_cubit.dart';
import 'package:homeapp/app/home/blocs/tasks_cubit/tasks_cubit.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../injection.dart';
import '../blocs/join_home/join_home_cubit.dart';
import '../views/join_home_view.dart';
import 'create_home_screen.dart';

class NoHomeScreen extends StatelessWidget {
  const NoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const Center(
                child: Text(
                  "You don't have a home yet. Join or create one to get started!",
                  style: TextStyle(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF38963E))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<TasksCubit>(context),
                                child: CreateHomeScreen(),
                              ),
                            ));
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (modalContext) {
                            return BlocProvider(
                              create: (context) => JoinHomeCubit(locator(),
                                  homesCubit: context.read<HomesCubit>()),
                              child: const JoinHomeView(),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Join",
                        style: TextStyle(
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
