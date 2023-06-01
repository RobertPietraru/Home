import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/routing/app_router.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/widgets/are_you_sure_dialog.dart';
import 'package:testador/features/quiz/presentation/session/admin/round_admin_screen.dart';
import 'package:testador/features/quiz/presentation/session/podium_screen.dart';
import 'package:testador/features/quiz/presentation/session/question_results_screen.dart';
import 'package:testador/features/quiz/presentation/session/admin/session_admin_cubit/session_admin_cubit.dart';
import 'package:testador/features/quiz/presentation/session/waiting_for_players_screen.dart';
import 'package:testador/injection.dart';

import '../player/round_player_screen.dart';
import '../leaderboard_screen.dart';

@RoutePage()
class QuizSessionManagerScreen extends StatelessWidget {
  final QuizEntity quiz;
  const QuizSessionManagerScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionAdminCubit(locator(), locator(), locator(),
          locator(), locator(), locator(), locator(), locator(),
          quiz: quiz),
      child: _QuizSessionManagerScreen(),
    );
  }
}

class _QuizSessionManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<SessionAdminCubit>();
        final result = await showDialog(
          context: context,
          builder: (context) =>  AreYouSureDialog(
              text: context.translator.ifYouLeaveSession,
              option1: context.translator.leave,
              option2: context.translator.stay),
        );
        if (result == null) {
          return false;
        }
        if (result == false) {
          // the user wants to leave
          cubit.deleteAndUnsubscribe();
          return true;
        }

        return false;
      },
      child: BlocBuilder<SessionAdminCubit, SessionAdminState>(
        builder: (context, state) {
          if (state is SessionAdminMatchState) {
            final status = state.session.status;
            if (status == SessionStatus.waitingForPlayers) {
              return WaitingForPlayersScreen(
                session: state.session,
                onBegin: () => context.read<SessionAdminCubit>().beginSession(),
              );
            } else if (status == SessionStatus.question) {
              return AdminRoundScreen(
                session: state.session,
                currentQuestion: state.currentQuestion,
                currentQuestionIndex: state.currentQuestionIndex,
                onContinue: () =>
                    context.read<SessionAdminCubit>().showQuestionResults(),
              );
            } else if (status == SessionStatus.results) {
              return QuestionResultsScreen(
                currentQuestion: state.currentQuestion,
                currentQuestionIndex: state.currentQuestionIndex,
                session: state.session,
                onContinue: () =>
                    context.read<SessionAdminCubit>().showLeaderboard(),
              );
            } else if (status == SessionStatus.leaderboard) {
              return LeaderboardScreen(
                onContinue: () =>
                    context.read<SessionAdminCubit>().goToNextQuestion(),
                session: state.session,
              );
            } else if (status == SessionStatus.podium) {
              return PodiumScreen(
                quiz: state.quiz,
                session: state.session,
              );
            }
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}
