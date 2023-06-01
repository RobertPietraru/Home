import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/buttons/long_button.dart';
import 'package:testador/core/components/theme/app_theme.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_list/cubit/quiz_list_cubit.dart';
import '../../../../core/routing/app_router.gr.dart';
import '../../domain/entities/draft_entity.dart';
import '../../domain/entities/quiz_entity.dart';

@RoutePage()
class QuizScreen extends StatelessWidget {
  const QuizScreen(
      {super.key,
      @PathParam('id') required this.quizId,
      required this.quiz,
      this.draft,
      required this.quizListCubit});
  final String quizId;
  final QuizEntity quiz;
  final DraftEntity? draft;
  final QuizListCubit quizListCubit;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final translator = AppLocalizations.of(context);
    // I wanted to be able to use the word quiz without using the inital quiz,
    final quiz0 = quiz;
    return BlocProvider.value(
      value: quizListCubit,
      child: Builder(builder: (context) {
        return BlocBuilder<QuizListCubit, QuizListState>(
          builder: (context, state) {
            late QuizEntity quiz;
            int index = state.pairs
                .indexWhere((element) => element.quiz.id == quiz0.id);
            if (index == -1) {
              quiz = quiz0;
            } else {
              quiz = state.pairs[index].quiz;
            }

            return Scaffold(
              appBar: const CustomAppBar(showLeading: true, showPlay:  false,),
              body: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                quiz.imageUrl ?? theme.placeholderImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: theme.standardPadding,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(quiz.title ?? translator.noTitle,
                                      style: theme.titleTextStyle),
                                  IconButton(
                                    onPressed: () {
                                      context.pushRoute(
                                        QuizEditorRoute(
                                          quizId: quiz.id,
                                          quiz: quiz,
                                          draft: draft,
                                          quizListCubit: quizListCubit,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: theme.standardPadding
                                  .copyWith(top: 0, bottom: 0),
                              child: SizedBox(
                                width: DeviceSize.isDesktopMode
                                    ? 40.widthPercent
                                    : null,
                                child: LongButton(
                                  onPressed: () => context.pushRoute(
                                      QuizSessionManagerRoute(quiz: quiz)),
                                  label: translator.startNewSession,
                                  isLoading: false,
                                ),
                              ),
                            ),
                          ],
                        )
                      ]))
                    ];
                  },
                  body: ListView.builder(
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, index) => QuestionWidget(
                      question: quiz.questions[index],
                      index: index,
                    ),
                  )),
            );
          },
        );
      }),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final int index;
  final QuestionEntity question;
  const QuestionWidget({
    super.key,
    required this.index,
    required this.question,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final translator = AppLocalizations.of(context);

    return Padding(
      padding: theme.standardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.index + 1}. ${widget.question.text ?? translator.someoneForgotTo}",
            style: theme.informationTextStyle,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final option = widget.question.options[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                key: ValueKey(option),
                leading: option.isCorrect
                    ? Icon(Icons.done, color: theme.good)
                    : Icon(Icons.close, color: theme.bad),
                title: Text(option.text ?? translator.option),
              );
            },
            itemCount: widget.question.options.length,
          )
        ],
      ),
    );
  }
}
