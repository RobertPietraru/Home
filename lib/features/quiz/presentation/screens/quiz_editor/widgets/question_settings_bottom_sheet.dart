import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/theme/app_theme.dart';
import '../../../../domain/entities/question_entity.dart';
import '../cubit/quiz_editor_cubit.dart';
import 'image_retrival_dialog.dart';

class QuestionSettingsView extends StatelessWidget {
  final QuestionEntity entity;
  final int questionIndex;
  const QuestionSettingsView({
    super.key,
    required this.entity,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return BlocBuilder<QuizEditorCubit, QuizEditorState>(
      builder: (context, state) {
        return Container(
          padding: theme.standardPadding,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  onTap: () {
                    context.read<QuizEditorCubit>().suggestOptions();
                    Navigator.pop(context);
                  },
                  title: Text(
                    context.translator.suggestContentWithAI,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.diversity_2),
                ),
                ListTile(
                  onTap: () {
                    context
                        .read<QuizEditorCubit>()
                        .addAnotherRowOfOptions(questionIndex: questionIndex);
                    Navigator.pop(context);
                  },
                  title: Text(
                    context.translator.addOptionsRow,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.add),
                ),
                ListTile(
                  onTap: () {
                    context
                        .read<QuizEditorCubit>()
                        .removeRowOfOptions(questionIndex: questionIndex);
                    Navigator.pop(context);
                  },
                  title: Text(
                    context.translator.removeOptionsRow,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.remove),
                ),
                ListTile(
                  onTap: () {
                    final cubit = context.read<QuizEditorCubit>();

                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_) => ImageRetrivalDialog(
                              onImageRetrived: (imageFile) {
                                cubit.updateQuestionImage(image: imageFile);
                              },
                            ));
                  },
                  title: Text(
                    state.currentQuestion.image == null
                        ? context.translator.addImage
                        : context.translator.changeImage,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.image),
                ),
                ListTile(
                  onTap: () {
                    context
                        .read<QuizEditorCubit>()
                        .deleteQuestion(index: state.currentQuestionIndex);
                    Navigator.pop(context);
                  },
                  title: Text(
                    context.translator.deleteQuestion,
                    style: TextStyle(
                        color: theme.bad, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.delete, color: theme.bad),
                )
              ]),
        );
      },
    );
  }
}
