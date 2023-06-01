import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/cubit/quiz_editor_cubit.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/quiz_settings_screen.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/views/questions_navigator.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/widgets/are_you_sure_dialog.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/widgets/option_widget.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_list/cubit/quiz_list_cubit.dart';
import 'package:testador/injection.dart';
import '../../../../../core/components/theme/app_theme.dart';

@RoutePage()
class QuizEditorScreen extends StatelessWidget {
  const QuizEditorScreen(
      {super.key,
      @PathParam('id') required this.quizId,
      required this.quiz,
      required this.quizListCubit,
      this.draft});
  final String quizId;
  final QuizEntity quiz;
  final DraftEntity? draft;
  final QuizListCubit quizListCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => QuizEditorCubit(
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              locator(),
              initialDraft: draft,
              quizListCubit: quizListCubit,
              initialQuiz: quiz,
            ),
        child: const _QuizScreen());
  }
}

class _QuizScreen extends StatefulWidget {
  const _QuizScreen();

  @override
  State<_QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<_QuizScreen> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<QuizEditorCubit>();
        if (!cubit.state.needsSync) {
          return true;
        }
        final bool? gottaSave = await showDialog(
          context: context,
          builder: (context) => AreYouSureDialog(
              text: context.translator.areYouSureNoSave,
              option1: context.translator.yes,
              option2: context.translator.save),
        );
        if (gottaSave == null) {
          // it was dissmissed;
          return false;
        }

        if (gottaSave) {
          cubit.save();
        } else {
          cubit.deleteDraft();
        }
        return true;
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primaryColor,
              onPressed: () {
                context.read<QuizEditorCubit>().addNewQuestion();
                controller.jumpTo(0);
              },
              child: const Icon(Icons.add)),
          backgroundColor: theme.defaultBackgroundColor.withOpacity(0.9),
          resizeToAvoidBottomInset: true,
          bottomSheet: BlocBuilder<QuizEditorCubit, QuizEditorState>(
            builder: (context, state) => SizedBox(
                height: 100,
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    context
                        .read<QuizEditorCubit>()
                        .moveQuestion(oldIndex: oldIndex, newIndex: newIndex);
                  },
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      state.draft.questions.length,
                      (index) => QuestionNavigatorListTile(
                          key: ValueKey('$index'),
                          isSelected: state.currentQuestionIndex == index,
                          onPressed: () {
                            context
                                .read<QuizEditorCubit>()
                                .navigateToIndex(index);
                            controller.jumpTo(0);
                          },
                          index: index,
                          question: state.draft.questions[index])),
                )),
          ),
          appBar: CustomAppBar(
              title: Text(context.translator.testEditor),
              trailing: [
                IconButton(
                    onPressed: () {
                      if (DeviceSize.isDesktopMode) {
                        showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: context.read<QuizEditorCubit>(),
                                  child: const QuizSettingsScreen(
                                      isFullScreen: false),
                                ));
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<QuizEditorCubit>(),
                              child:
                                  const QuizSettingsScreen(isFullScreen: true),
                            ),
                          ));
                    },
                    icon: const Icon(Icons.settings)),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<QuizEditorCubit, QuizEditorState>(
                        builder: (context, state) {
                      return FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                state.needsSync
                                    ? theme.good
                                    : theme.secondaryColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ))),
                        onPressed: state.needsSync
                            ? () => context.read<QuizEditorCubit>().save()
                            : null,
                        child: Text(context.translator.save),
                      );
                    }))
              ]),
          body: BlocConsumer<QuizEditorCubit, QuizEditorState>(
            listener: (context, state) {
              if (state.status == QuizEditorStatus.failed &&
                  state.failure != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.failure!.retrieveMessage(context))));
              }
            },
            builder: (context, state) {
              if (state.status == QuizEditorStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return NestedScrollView(
                  controller: controller,
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                            padding: theme.standardPadding
                                .copyWith(top: 0, bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuizQuestionWidget(state: state),
                                SizedBox(height: theme.spacing.xLarge),
                                if (state.currentQuestion.image != null)
                                  Center(
                                    child: SizedBox(
                                      height: 40.heightPercent,
                                      child: Image.network(
                                          state.currentQuestion.image!,
                                          fit: BoxFit.contain),
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: state.currentQuestion.options.length,
                          itemBuilder: (context, index) => EditorOptionWidget(
                              index: index,
                              option: state.currentQuestion.options[index])),
                    ),
                  ));
            },
          )),
    );
  }
}
