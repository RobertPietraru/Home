import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/buttons/long_button.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/text_input_field.dart';
import 'package:testador/core/routing/app_router.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/podium_screen.dart';
import 'package:testador/features/quiz/presentation/session/leaderboard_screen.dart';
import 'package:testador/features/quiz/presentation/session/player/cubit/session_player_cubit.dart';
import 'package:testador/features/quiz/presentation/session/question_results_screen.dart';
import 'package:testador/features/quiz/presentation/session/player/round_player_screen.dart';
import 'package:testador/features/quiz/presentation/session/waiting_for_players_screen.dart';
import 'package:testador/injection.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/components/theme/app_theme.dart';
import '../../../../../core/components/theme/device_size.dart';

@RoutePage()
class PlayerSessionManagerScreen extends StatelessWidget {
  const PlayerSessionManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionPlayerCubit(
          locator(), locator(), locator(), locator(),
          userId: const Uuid().v1()),
      child: Builder(builder: (context) {
        return BlocBuilder<SessionPlayerCubit, SessionPlayerState>(
          buildWhen: (previous, current) {
            if (current is! SessionPlayerInGame ||
                previous is! SessionPlayerInGame) {
              return true;
            }
            // rebuild only on page change, otherwise, there is no reason
            if (current.session.status != previous.session.status) {
              return true;
            }

            return false;
          },
          builder: (context, state) {
            if (state is SessionPlayerCodeRetrival) {
              return CodeRetrivalScreen(state: state);
            } else if (state is SessionPlayerNameRetrival) {
              return NameRetrivalScreen(state: state);
            } else {
              state as SessionPlayerInGame;
              switch (state.session.status) {
                case SessionStatus.waitingForPlayers:
                  return WaitingForPlayersScreen(session: state.session);
                case SessionStatus.question:
                  return PlayerRoundScreen(
                    session: state.session,
                    currentQuestionIndex: state.currentQuestionIndex,
                    currentQuestion: state.currentQuestion,
                    userId: state.userId,
                  );
                case SessionStatus.results:
                  return QuestionResultsScreen(
                      session: state.session,
                      currentQuestion: state.currentQuestion,
                      currentQuestionIndex: state.currentQuestionIndex);
                case SessionStatus.leaderboard:
                  return LeaderboardScreen(session: state.session);
                case SessionStatus.podium:
                  return PodiumScreen(
                    quiz: state.quiz,
                    session: state.session,
                  );
                default:
                  return const LoadingScreen();
              }
            }
          },
        );
      }),
    );
  }
}

class CodeRetrivalScreen extends StatelessWidget {
  final SessionPlayerCodeRetrival state;
  const CodeRetrivalScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SizedBox(
          width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
          child: Padding(
            padding: theme.standardPadding,
            child: Column(
                mainAxisAlignment: DeviceSize.isDesktopMode
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translator.insertCodeToConnect,
                        style: theme.titleTextStyle,
                      ),
                      SizedBox(height: theme.spacing.small),
                      TextInputField(
                        keyboardType: TextInputType.number,
                        initialValue: state.sessionId,
                        onChanged: (e) =>
                            context.read<SessionPlayerCubit>().updateCode(e),
                        error: state.failure?.retrieveMessage(context),
                        hint: context.translator.code,
                        showLabel: false,
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.large),
                  LongButton(
                    onPressed: () =>
                        context.read<SessionPlayerCubit>().subscribeToSession(),
                    label: context.translator.searchForSession,
                    isLoading: state.isLoading,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class NameRetrivalScreen extends StatelessWidget {
  final SessionPlayerNameRetrival state;
  const NameRetrivalScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(showPlay: false),
      body: Center(
        child: SizedBox(
          width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
          child: Padding(
            padding: theme.standardPadding,
            child: Column(
                mainAxisAlignment: DeviceSize.isDesktopMode
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translator.chooseAName,
                        style: theme.titleTextStyle,
                      ),
                      SizedBox(height: theme.spacing.small),
                      TextInputField(
                        initialValue: state.name,
                        onChanged: (e) => context
                            .read<SessionPlayerCubit>()
                            .updateName(e.replaceAll(' ', '')),
                        hint: context.translator.name,
                        error: state.failure?.retrieveMessage(context),
                        showLabel: false,
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.large),
                  LongButton(
                    onPressed: () =>
                        context.read<SessionPlayerCubit>().joinSession(),
                    label: context.translator.connect,
                    isLoading: false,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
