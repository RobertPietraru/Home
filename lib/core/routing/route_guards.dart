import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/routing/app_router.gr.dart';
import 'package:testador/features/authentication/presentation/auth_bloc/auth_bloc.dart';

class AuthGuard extends AutoRedirectGuardBase {
  AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation

    if (router.navigatorKey.currentContext?.read<AuthBloc>().state
        is AuthAuthenticatedState) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      router.push(const AuthenticationFlowRoute());
    }
  }

  @override
  Future<bool> canNavigate(RouteMatch route) async {
    return true;
  }
}
