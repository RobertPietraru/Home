import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/theme/app_theme.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/core/routing/app_router.gr.dart';
import 'package:testador/features/quiz/domain/entities/draft_entity.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_list/widgets/quiz_widget/quiz_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../injection.dart';
import '../../../../authentication/presentation/auth_bloc/auth_bloc.dart';
import 'cubit/quiz_list_cubit.dart';

@RoutePage()
class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizListCubit(locator(), locator(), locator())
        ..getQuizes(creatorId: context.read<AuthBloc>().state.userEntity!.id),
      child: const _QuizListScreen(),
    );
  }
}

class _QuizListScreen extends StatelessWidget {
  const _QuizListScreen();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final translator = AppLocalizations.of(context);
    return Scaffold(
        appBar: const CustomAppBar(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.companyColor,
          onPressed: () => context.read<QuizListCubit>().createQuiz(
              creatorId: context.read<AuthBloc>().state.userEntity!.id,
              onCreated: (draft) => goToQuizEditor(context, draft)),
          child: const Icon(Icons.add),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding:
                          theme.standardPadding.copyWith(top: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Text(
                                '${translator.welcome}!',
                                style: TextStyle(
                                  color: theme.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: theme.spacing.large,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: theme.spacing.medium),
                          Center(
                            child: SizedBox(
                              width: DeviceSize.isDesktopMode
                                  ? 30.widthPercent
                                  : null,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _QuickActionWidget(
                                      onPressed: () {
                                        context.router.root.push(
                                            const PlayerSessionManagerRoute());
                                      },
                                      icon: Icons.people_alt,
                                      label: translator.play,
                                    ),
                                    _QuickActionWidget(
                                      icon: Icons.arrow_back,
                                      label: translator.continueText,
                                      isEnabled: false,
                                      onPressed: null,
                                    ),
                                    _QuickActionWidget(
                                        icon: Icons.lightbulb,
                                        label: translator.create,
                                        onPressed: () => context
                                            .read<QuizListCubit>()
                                            .createQuiz(
                                                creatorId: context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .userEntity!
                                                    .id,
                                                onCreated: (draft) =>
                                                    goToQuizEditor(
                                                        context, draft)))
                                  ]),
                            ),
                          ),
                          SizedBox(height: theme.spacing.medium),
                          BlocBuilder<QuizListCubit, QuizListState>(
                            builder: (context, state) {
                              if (state is! QuizListEmpty) {
                                return Text(
                                  translator.yourTests,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: theme.spacing.xxLarge,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ];
            },
            body: BlocConsumer<QuizListCubit, QuizListState>(
              listener: (context, state) {
                if (state is QuizListError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.failure.retrieveMessage(context))));
                }
              },
              builder: (context, state) {
                if (state is QuizListEmpty) {
                  return Center(
                    child: Text(
                      "${translator.noTests}\n"
                      "¯\\_(ツ)_/¯",
                      textAlign: TextAlign.center,
                      style: theme.largetitleTextStyle
                          .copyWith(color: theme.secondaryColor),
                    ),
                  );
                }
                if (state is QuizListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (DeviceSize.isDesktopMode) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: DeviceSize.screenHeight ~/ 200,
                      ),
                      itemCount: state.pairs.length,
                      itemBuilder: (context, index) => Padding(
                          padding: theme.standardPadding,
                          child: QuizWidget(quiz: state.pairs[index].quiz)));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<QuizListCubit>().getQuizes(
                              creatorId:
                                  context.read<AuthBloc>().state.userEntity!.id,
                            ),
                    child: ListView.builder(
                        itemCount: state.pairs.length,
                        itemBuilder: (context, index) => Padding(
                            padding: theme.standardPadding,
                            child: QuizWidget(
                              quiz: state.pairs[index].quiz,
                              draft: state.pairs[index].draft,
                            ))),
                  );
                }
              },
            )));
  }

  void goToQuizEditor(BuildContext context, DraftEntity draft) {
    final canPush = Navigator.maybeOf(context) != null;
    if (canPush) {
      context.pushRoute(QuizEditorRoute(
        draft: draft,
        quizListCubit: context.read<QuizListCubit>(),
        quizId: draft.id,
        quiz: draft.toQuiz(),
      ));
    }
  }
}

class _QuickActionWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;
  const _QuickActionWidget(
      {required this.label,
      required this.icon,
      required this.onPressed,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: Ink(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: !isEnabled ? Colors.grey : null,
                child: Icon(icon, color: !isEnabled ? Colors.white : null),
              ),
              Text(
                label,
                style: TextStyle(
                  color: !isEnabled ? Colors.grey : null,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionOptionWidget extends StatefulWidget {
  const SelectionOptionWidget({
    super.key,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onPressed,
  });

  final String title;
  final String description;
  final LinearGradient? gradient;
  final VoidCallback onPressed;

  @override
  State<SelectionOptionWidget> createState() => _SelectionOptionWidgetState();
}

class _SelectionOptionWidgetState extends State<SelectionOptionWidget> {
  bool isPressedOn = false;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTapDown: (details) => setState(() => isPressedOn = true),
      onTapUp: (details) => setState(() => isPressedOn = false),
      onTap: widget.onPressed,
      child: Container(
        height: DeviceSize.isDesktopMode ? 130 : null,
        width: 100.widthPercent,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: widget.gradient?.scale(isPressedOn ? 0.8 : 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title, style: theme.titleTextStyle),
              Text(widget.description,
                  style: theme.informationTextStyle
                      .copyWith(fontWeight: FontWeight.w500)),
            ]),
      ),
    );
  }
}
