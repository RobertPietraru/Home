import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeapp/core/components/app_logo.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:household/household.dart';

import '../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../screens/invite_to_home_screen.dart';

class DrawerView extends StatelessWidget {
  final HomeEntity home;
  const DrawerView({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const AppLogo(size: 50),
                  const SizedBox(height: 10),
                  Text(home.name,
                      style:
                          TextStyle(fontSize: 25, color: theme.secondaryColor)),
                  const SizedBox(height: 20),
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InviteToHomeScreen(homeEntity: home))),
                    leading: const Icon(
                      Icons.person_add,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Invite people",
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  context.read<AuthBloc>().add(AuthUserLoggedOut());
                },
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
