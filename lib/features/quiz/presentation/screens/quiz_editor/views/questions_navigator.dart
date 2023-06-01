import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/theme/device_size.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/theme/app_theme.dart';
import '../../../../domain/entities/question_entity.dart';
import '../cubit/quiz_editor_cubit.dart';
import '../widgets/edit_question_dialog.dart';
import '../widgets/question_settings_bottom_sheet.dart';

class QuestionNavigatorListTile extends StatelessWidget {
  final int index;
  final QuestionEntity question;
  final VoidCallback onPressed;
  final bool isSelected;
  const QuestionNavigatorListTile({
    super.key,
    required this.index,
    required this.question,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Card(
      color: isSelected ? Colors.blue[900] : Colors.blue,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 84,
                child: Text(
                  question.text ?? context.translator.someoneForgotTo,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: theme.spacing.small),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              question.image ?? theme.placeholderImage))),
                ),
              ),
              Text(
                (index + 1).toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizQuestionWidget extends StatelessWidget {
  final QuizEditorState state;
  const QuizQuestionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<QuizEditorCubit>(context),
                  child: EditQuestionDialog(
                      initialValue: state.currentQuestion.text ?? ''))),
          child: Text(
            "${(state.currentQuestionIndex + 1).toString()}. ${state.currentQuestion.text ?? context.translator.tapToModifyQuestion}",
            style: theme.subtitleTextStyle,
          ),
        ),
      ),
      InkWell(
          onTap: () {
            if (DeviceSize.isDesktopMode) {
              showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<QuizEditorCubit>(context),
                        child: Dialog(
                          child: QuestionSettingsView(
                            questionIndex: state.currentQuestionIndex,
                            entity: state.currentQuestion,
                          ),
                        ),
                      ));
              return;
            }
            showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<QuizEditorCubit>(context),
                      child: QuestionSettingsView(
                        questionIndex: state.currentQuestionIndex,
                        entity: state.currentQuestion,
                      ),
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0))));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black),
            child: const Icon(Icons.more_vert, color: Colors.white),
          ))
    ]);
  }
}
