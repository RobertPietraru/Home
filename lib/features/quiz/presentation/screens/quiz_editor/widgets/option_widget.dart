import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/theme/app_theme.dart';
import '../../../../domain/entities/question_entity.dart';
import '../cubit/quiz_editor_cubit.dart';
import 'edit_option_dialog.dart';

class EditorOptionWidget extends StatefulWidget {
  final int index;
  final MultipleChoiceOptionEntity option;
  const EditorOptionWidget({
    super.key,
    required this.index,
    required this.option,
  });

  @override
  State<EditorOptionWidget> createState() => _EditorOptionWidgetState();
}

class _EditorOptionWidgetState extends State<EditorOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.option.text != null;
    final theme = AppTheme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<QuizEditorCubit>(),
              child: EditOptionDialog(
                entity: widget.option,
                index: widget.index,
              ),
            ),
          );
        },
        child: Ink(
          color:
              isEnabled ? theme.getColor(widget.index) : theme.secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Center(
                child: Text(
                  widget.option.text ??
                      "${context.translator.option} ${widget.index + 1}",
                  style: theme.questionTextStyle,
                ),
              ),
              IconButton(
                  onPressed: () => context
                      .read<QuizEditorCubit>()
                      .updateCurrentQuestionOption(
                          optionIndex: widget.index,
                          newOption: MultipleChoiceOptionEntity(
                              text: widget.option.text,
                              isCorrect: !widget.option.isCorrect)),
                  icon:
                      Icon(widget.option.isCorrect ? Icons.done : Icons.close))
            ],
          ),
        ),
      ),
    );
  }
}
