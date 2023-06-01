import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../auth_bloc/auth_bloc.dart';

class AuthBlocWidget extends StatelessWidget {
  final Widget child;
  const AuthBlocWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(locator(), locator()),
      child: child,
    );
  }
}
