import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/presentation/auth_bloc/auth_bloc.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
        page: AuthenticationWrapperRoute.page,
        path: '/',
        initial: true,
        children: [
          AutoRoute(
              // initial: true,
              path: 'auth',
              page: AuthenticationFlowRoute.page,
              children: [
                AutoRoute(
                    initial: true,
                    page: RegistrationRoute.page,
                    path: 'signup'),
                AutoRoute(page: LoginRoute.page, path: 'loginin'),
              ]),
          AutoRoute(
              path: 'protected',
              page: ProtectedFlowRoute.page,
              children: [
                AutoRoute(path: 'quiz-admin/:id', page: QuizEditorRoute.page),
                AutoRoute(path: 'quiz/:id', page: QuizRoute.page),
                AutoRoute(
                    path: 'session-create/:id',
                    page: QuizSessionManagerRoute.page),
                AutoRoute(initial: true, page: QuizListRoute.page, path: ''),
              ]),
          AutoRoute(path: 'loading', page: LoadingRoute.page),
        ]),
    AutoRoute(page: PlayerSessionManagerRoute.page, path: '/join')
  ];
}

@RoutePage(name: 'AuthenticationFlowRoute')
class AuthenticationFlow extends StatelessWidget {
  const AuthenticationFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage(name: 'AuthenticationWrapperRoute')
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
    return AutoRouter.declarative(routes: (_) {
      if (authBloc.state is AuthUninitialisedState) {
        return [const LoadingRoute()];
      }
      if (authBloc.state is AuthAuthenticatedState) {
        return [const ProtectedFlowRoute()];
      }
      return [const AuthenticationFlowRoute()];
    });
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage(name: 'ProtectedFlowRoute')
class ProtectedFlow extends StatelessWidget {
  const ProtectedFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
