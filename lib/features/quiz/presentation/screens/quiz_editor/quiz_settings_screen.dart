import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/components/custom_dialog.dart';
import 'package:testador/core/components/text_input_field.dart';
import 'package:testador/core/components/theme/app_theme.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/cubit/quiz_editor_cubit.dart';
import 'package:testador/features/quiz/presentation/screens/quiz_editor/widgets/image_retrival_dialog.dart';

class QuizSettingsScreen extends StatelessWidget {
  final bool isFullScreen;

  const QuizSettingsScreen({super.key, required this.isFullScreen});

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return const Scaffold(
        appBar: CustomAppBar(trailing: []),
        body: QuizSettingsView(
          isFullScreen: true,
        ),
      );
    }
    return const CustomDialog(
      fitContent: true,
      child: QuizSettingsView(
        isFullScreen: false,
      ),
    );
  }
}

class QuizSettingsView extends StatefulWidget {
  final bool isFullScreen;
  const QuizSettingsView({
    super.key,
    required this.isFullScreen,
  });

  @override
  State<QuizSettingsView> createState() => _QuizSettingsViewState();
}

class _QuizSettingsViewState extends State<QuizSettingsView> {
  late String title;
  late String initialTitle;
  late String lesson;
  late String initialLesson;
  @override
  void initState() {
    final quiz = context.read<QuizEditorCubit>().state.draft;
    title = quiz.title ?? '';
    initialTitle = title;

    lesson = quiz.lesson ?? '';
    initialLesson = lesson;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (initialTitle == title && initialLesson == lesson) {
          return true;
        }
        if (title.isEmpty && lesson.isEmpty) {
          return true;
        }

        context
            .read<QuizEditorCubit>()
            .updateQuiz(title: title, lesson: lesson);

        return true;
      },
      child: BlocBuilder<QuizEditorCubit, QuizEditorState>(
        builder: (context, state) {
          return Container(
            padding: widget.isFullScreen ? theme.standardPadding : null,
            width: DeviceSize.isDesktopMode ? 50.widthPercent : null,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  InkWell(
                      // borderRadius: BorderRadius.circular(20),
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: context.read<QuizEditorCubit>(),
                              child: ImageRetrivalDialog(
                                  onImageRetrived: (imageFile) {
                                context
                                    .read<QuizEditorCubit>()
                                    .updateQuizImage(newImage: imageFile);
                              }))),
                      child: Material(
                        child: Ink(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: theme.secondaryColor,
                              image: state.draft.imageUrl != null
                                  ? DecorationImage(
                                      image:
                                          NetworkImage(state.draft.imageUrl!))
                                  : null,
                            ),
                            child: state.draft.imageUrl == null
                                ? Center(
                                    child: Text(context.translator.addImage,
                                        textAlign: TextAlign.center,
                                        style: theme.subtitleTextStyle
                                            .copyWith(color: Colors.white)))
                                : null),
                      ))
                ]),
                SizedBox(height: theme.spacing.small),
                TextInputField(
                    initialValue: title,
                    onChanged: (e) {
                      title = e;
                    },
                    hint: context.translator.title),
                SizedBox(height: theme.spacing.small),
                TextInputField(
                  onChanged: (e) {
                    lesson = e;
                  },
                  initialValue: initialLesson,
                  hint: context.translator.lesson,
                  maxLines: 5,
                ),
                SizedBox(height: theme.spacing.small),
                ListTile(
                  leading: Icon(
                      state.draft.isPublic ? Icons.public : Icons.public_off,
                      color: state.draft.isPublic ? theme.good : theme.bad),
                  onTap: () =>
                      context.read<QuizEditorCubit>().togglePublicity(),
                  title: Text(
                    state.draft.isPublic
                        ? context.translator.public
                        : context.translator.private,
                    style: theme.subtitleTextStyle.copyWith(
                        color: state.draft.isPublic ? theme.good : theme.bad),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
