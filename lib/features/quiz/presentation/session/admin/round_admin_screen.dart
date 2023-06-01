import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/timer/question_timer_cubit.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_code_widget.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_option_widget.dart';

import '../../../../../core/components/buttons/app_bar_button.dart';
import '../../../../../core/components/custom_app_bar.dart';
import '../../../../../core/components/theme/app_theme.dart';
import '../../../../../core/components/theme/device_size.dart';
import '../../../domain/entities/question_entity.dart';

class AdminRoundScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final int currentQuestionIndex;
  final QuestionEntity currentQuestion;
  final SessionEntity session;

  const AdminRoundScreen({
    super.key,
    required this.onContinue,
    required this.session,
    required this.currentQuestionIndex,
    required this.currentQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionTimerCubit(time: 40),
      child: Builder(builder: (context) {
        return BlocListener<QuestionTimerCubit, QuestionTimerState>(
          listenWhen: (previous, current) => current.time == 0,
          listener: (context, state) => onContinue(),
          child: _RoundAdminScreen(
            currentQuestion: currentQuestion,
            currentQuestionIndex: currentQuestionIndex,
            session: session,
            onContinue: onContinue,
          ),
        );
      }),
    );
  }
}

class _RoundAdminScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final int currentQuestionIndex;
  final QuestionEntity currentQuestion;
  final SessionEntity session;

  const _RoundAdminScreen({
    required this.onContinue,
    required this.session,
    required this.currentQuestionIndex,
    required this.currentQuestion,
  });

  @override
  State<_RoundAdminScreen> createState() => _RoundAdminScreenState();
}

class _RoundAdminScreenState extends State<_RoundAdminScreen> {
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
          title: SessionCodeWidget(sessionId: widget.session.id),
          trailing: [
            AppBarButton(text: context.translator.continueText, onPressed: widget.onContinue)
          ]),
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
                              "${(widget.currentQuestionIndex + 1).toString()}. ${widget.currentQuestion.text ?? context.translator.someoneForgotTo}",
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
                      if (widget.currentQuestion.image != null)
                        Center(
                          child: Container(
                            height: 220,
                            color: theme.secondaryColor,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.network(
                                  widget.currentQuestion.image!,
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
        body: Center(
          child: SizedBox(
            width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: widget.currentQuestion.options.length,
                itemBuilder: (context, index) => SessionOptionWidget(
                    index: index,
                    option: widget.currentQuestion.options[index],
                    isSelected: false,
                    onPressed: null)),
          ),
        ),
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
