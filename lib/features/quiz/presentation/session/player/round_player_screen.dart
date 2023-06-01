import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/routing/app_router.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/player/player_question/player_question_cubit.dart';
import 'package:testador/features/quiz/presentation/session/timer/question_timer_cubit.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_code_widget.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_option_widget.dart';

import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/components/theme/app_theme.dart';
import '../../../../../injection.dart';
import '../../../domain/entities/question_entity.dart';

class PlayerRoundScreen extends StatelessWidget {
  final int currentQuestionIndex;
  final QuestionEntity currentQuestion;
  final SessionEntity session;
  final String userId;

  const PlayerRoundScreen({
    super.key,
    required this.session,
    required this.currentQuestionIndex,
    required this.currentQuestion,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => QuestionTimerCubit(time: 40)),
        BlocProvider(
            create: (context) => PlayerQuestionCubit(locator(),
                questionindex: currentQuestionIndex,
                question: currentQuestion,
                session: session,
                timer: context.read<QuestionTimerCubit>(),
                userId: userId)),
      ],
      child: Builder(builder: (context) {
        return BlocListener<QuestionTimerCubit, QuestionTimerState>(
          listenWhen: (previous, current) => current.time == 0,
          listener: (context, state) =>
              context.read<PlayerQuestionCubit>().ranOutOfTime(),
          child: const _RoundPlayerScreen(),
        );
      }),
    );
  }
}

class _RoundPlayerScreen extends StatefulWidget {
  const _RoundPlayerScreen();

  @override
  State<_RoundPlayerScreen> createState() => _RoundPlayerScreenState();
}

class _RoundPlayerScreenState extends State<_RoundPlayerScreen> {
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<PlayerQuestionCubit, PlayerQuestionState>(
      builder: (context, state) {
        switch (state.status) {
          case PlayerQuestionStatus.thinking:
            return _AnswerRetrivalScreen(
              controller: controller,
              state: state,
            );
          case PlayerQuestionStatus.outOfTime:
            return Scaffold(
                body: Center(
                    child: Text(
              "${context.translator.youRanOutOfTime}\n"
              "¯\\_(ツ)_/¯",
              style: theme.largetitleTextStyle
                  .copyWith(color: theme.secondaryColor),
            )));
          case PlayerQuestionStatus.loading:
            return const LoadingScreen();
          case PlayerQuestionStatus.answered:
            return Scaffold(
                appBar: CustomAppBar(trailing: []),
                body: Center(
                    child: Text(
                  context.translator.responseRegistered,
                  textAlign: TextAlign.center,
                  style: theme.largetitleTextStyle
                      .copyWith(color: theme.secondaryColor),
                )));
          default:
            return const LoadingScreen();
        }
      },
    );
  }
}

class _AnswerRetrivalScreen extends StatelessWidget {
  final PlayerQuestionState state;
  final ScrollController controller;
  const _AnswerRetrivalScreen({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      floatingActionButton: state.question.hasMultipleAnswers &&
              state.selectedAnswerIndexes.isNotEmpty
          ? FloatingActionButton(
              onPressed: () =>
                  context.read<PlayerQuestionCubit>().sendSelectedAnswers(),
              child: const Icon(Icons.send),
            )
          : null,
      appBar: CustomAppBar(
          title: SessionCodeWidget(sessionId: state.session.id),
          trailing: const []),
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                  padding: theme.standardPadding.copyWith(top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${(state.questionIndex + 1).toString()}. ${state.question.text ?? context.translator.someoneForgotTo}",
                              style: theme.subtitleTextStyle,
                            ),
                          ),
                          SizedBox(width: theme.spacing.small),
                          BlocBuilder<QuestionTimerCubit, QuestionTimerState>(
                            builder: (context, state) {
                              return TimerWidget(seconds: state.time);
                            },
                          )
                        ],
                      ),
                      SizedBox(height: theme.spacing.medium),
                      if (state.question.image != null)
                        Center(
                          child: Container(
                            height: 220,
                            color: theme.secondaryColor,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.network(state.question.image!,
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      SizedBox(height: theme.spacing.medium),
                    ],
                  ))
            ]))
          ];
        },
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: state.question.options.length,
            itemBuilder: (context, index) => SessionOptionWidget(
                index: index,
                option: state.question.options[index],
                isSelected: state.selectedAnswerIndexes.contains(index),
                onPressed: () => context
                    .read<PlayerQuestionCubit>()
                    .onAnswerPressed(index))),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int seconds;
  final double size;
  final Color color;

  const TimerWidget(
      {super.key,
      required this.seconds,
      this.size = 80,
      this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
      child: Center(
          child: Text(seconds.toString(),
              style: theme.titleTextStyle.copyWith(color: Colors.white))),
    );
  }
}
