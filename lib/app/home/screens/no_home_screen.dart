import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/core/presentation/widgets/pietrocka_logo.dart';
import 'package:pietrocka_home/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/homes_bloc/homes_bloc.dart';
import 'package:pietrocka_home/features/tasks/presentation/blocs/join_home/join_home_cubit.dart';
import 'package:pietrocka_home/features/tasks/presentation/screens/create_home_screen.dart';
import 'package:pietrocka_home/features/tasks/presentation/views/join_home_view.dart';
import 'package:pietrocka_home/core/config/injection.dart';

import '../../../../core/presentation/navigation/navigation_cubit.dart';

class NoHomeScreen extends StatelessWidget {
  const NoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthLoggedOut());
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const PietrockaLogo(),
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
                        context
                            .read<NavigationCubit>()
                            .navigateTo(context, CreateHomeScreen());
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
                                  homesBloc: context.read<HomesBloc>()),
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
