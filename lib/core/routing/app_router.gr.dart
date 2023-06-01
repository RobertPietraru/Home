// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:testador/core/routing/app_router.dart' as _i1;
import 'package:testador/features/authentication/presentation/screens/login/login_screen.dart'
    as _i7;
import 'package:testador/features/authentication/presentation/screens/registration/registration_screen.dart'
    as _i8;
import 'package:testador/features/quiz/domain/entities/draft_entity.dart'
    as _i12;
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart'
    as _i11;
import 'package:testador/features/quiz/presentation/screens/quiz_editor/quiz_editor_screen.dart'
    as _i6;
import 'package:testador/features/quiz/presentation/screens/quiz_list/cubit/quiz_list_cubit.dart'
    as _i13;
import 'package:testador/features/quiz/presentation/screens/quiz_list/quiz_list_screen.dart'
    as _i4;
import 'package:testador/features/quiz/presentation/screens/quiz_screen.dart'
    as _i5;
import 'package:testador/features/quiz/presentation/session/admin/session_manager_screen.dart'
    as _i3;
import 'package:testador/features/quiz/presentation/session/player/player_session_manager.dart'
    as _i2;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AuthenticationFlowRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AuthenticationFlow(),
      );
    },
    AuthenticationWrapperRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AuthenticationWrapper(),
      );
    },
    ProtectedFlowRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ProtectedFlow(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoadingScreen(),
      );
    },
    PlayerSessionManagerRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.PlayerSessionManagerScreen(),
      );
    },
    QuizSessionManagerRoute.name: (routeData) {
      final args = routeData.argsAs<QuizSessionManagerRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.QuizSessionManagerScreen(
          key: args.key,
          quiz: args.quiz,
        ),
      );
    },
    QuizListRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.QuizListScreen(),
      );
    },
    QuizRoute.name: (routeData) {
      final args = routeData.argsAs<QuizRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.QuizScreen(
          key: args.key,
          quizId: args.quizId,
          quiz: args.quiz,
          draft: args.draft,
          quizListCubit: args.quizListCubit,
        ),
      );
    },
    QuizEditorRoute.name: (routeData) {
      final args = routeData.argsAs<QuizEditorRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.QuizEditorScreen(
          key: args.key,
          quizId: args.quizId,
          quiz: args.quiz,
          quizListCubit: args.quizListCubit,
          draft: args.draft,
        ),
      );
    },
    LoginDialogRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginDialog(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    RegistrationRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.RegistrationScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthenticationFlow]
class AuthenticationFlowRoute extends _i9.PageRouteInfo<void> {
  const AuthenticationFlowRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AuthenticationFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticationFlowRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i1.AuthenticationWrapper]
class AuthenticationWrapperRoute extends _i9.PageRouteInfo<void> {
  const AuthenticationWrapperRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AuthenticationWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticationWrapperRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i1.ProtectedFlow]
class ProtectedFlowRoute extends _i9.PageRouteInfo<void> {
  const ProtectedFlowRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ProtectedFlowRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProtectedFlowRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i1.LoadingScreen]
class LoadingRoute extends _i9.PageRouteInfo<void> {
  const LoadingRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i2.PlayerSessionManagerScreen]
class PlayerSessionManagerRoute extends _i9.PageRouteInfo<void> {
  const PlayerSessionManagerRoute({List<_i9.PageRouteInfo>? children})
      : super(
          PlayerSessionManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerSessionManagerRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i3.QuizSessionManagerScreen]
class QuizSessionManagerRoute
    extends _i9.PageRouteInfo<QuizSessionManagerRouteArgs> {
  QuizSessionManagerRoute({
    _i10.Key? key,
    required _i11.QuizEntity quiz,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          QuizSessionManagerRoute.name,
          args: QuizSessionManagerRouteArgs(
            key: key,
            quiz: quiz,
          ),
          initialChildren: children,
        );

  static const String name = 'QuizSessionManagerRoute';

  static const _i9.PageInfo<QuizSessionManagerRouteArgs> page =
      _i9.PageInfo<QuizSessionManagerRouteArgs>(name);
}

class QuizSessionManagerRouteArgs {
  const QuizSessionManagerRouteArgs({
    this.key,
    required this.quiz,
  });

  final _i10.Key? key;

  final _i11.QuizEntity quiz;

  @override
  String toString() {
    return 'QuizSessionManagerRouteArgs{key: $key, quiz: $quiz}';
  }
}

/// generated route for
/// [_i4.QuizListScreen]
class QuizListRoute extends _i9.PageRouteInfo<void> {
  const QuizListRoute({List<_i9.PageRouteInfo>? children})
      : super(
          QuizListRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuizListRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.QuizScreen]
class QuizRoute extends _i9.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    _i10.Key? key,
    required String quizId,
    required _i11.QuizEntity quiz,
    _i12.DraftEntity? draft,
    required _i13.QuizListCubit quizListCubit,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(
            key: key,
            quizId: quizId,
            quiz: quiz,
            draft: draft,
            quizListCubit: quizListCubit,
          ),
          rawPathParams: {'id': quizId},
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static const _i9.PageInfo<QuizRouteArgs> page =
      _i9.PageInfo<QuizRouteArgs>(name);
}

class QuizRouteArgs {
  const QuizRouteArgs({
    this.key,
    required this.quizId,
    required this.quiz,
    this.draft,
    required this.quizListCubit,
  });

  final _i10.Key? key;

  final String quizId;

  final _i11.QuizEntity quiz;

  final _i12.DraftEntity? draft;

  final _i13.QuizListCubit quizListCubit;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, quizId: $quizId, quiz: $quiz, draft: $draft, quizListCubit: $quizListCubit}';
  }
}

/// generated route for
/// [_i6.QuizEditorScreen]
class QuizEditorRoute extends _i9.PageRouteInfo<QuizEditorRouteArgs> {
  QuizEditorRoute({
    _i10.Key? key,
    required String quizId,
    required _i11.QuizEntity quiz,
    required _i13.QuizListCubit quizListCubit,
    _i12.DraftEntity? draft,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          QuizEditorRoute.name,
          args: QuizEditorRouteArgs(
            key: key,
            quizId: quizId,
            quiz: quiz,
            quizListCubit: quizListCubit,
            draft: draft,
          ),
          rawPathParams: {'id': quizId},
          initialChildren: children,
        );

  static const String name = 'QuizEditorRoute';

  static const _i9.PageInfo<QuizEditorRouteArgs> page =
      _i9.PageInfo<QuizEditorRouteArgs>(name);
}

class QuizEditorRouteArgs {
  const QuizEditorRouteArgs({
    this.key,
    required this.quizId,
    required this.quiz,
    required this.quizListCubit,
    this.draft,
  });

  final _i10.Key? key;

  final String quizId;

  final _i11.QuizEntity quiz;

  final _i13.QuizListCubit quizListCubit;

  final _i12.DraftEntity? draft;

  @override
  String toString() {
    return 'QuizEditorRouteArgs{key: $key, quizId: $quizId, quiz: $quiz, quizListCubit: $quizListCubit, draft: $draft}';
  }
}

/// generated route for
/// [_i7.LoginDialog]
class LoginDialogRoute extends _i9.PageRouteInfo<void> {
  const LoginDialogRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginDialogRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginDialogRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.RegistrationScreen]
class RegistrationRoute extends _i9.PageRouteInfo<void> {
  const RegistrationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}
