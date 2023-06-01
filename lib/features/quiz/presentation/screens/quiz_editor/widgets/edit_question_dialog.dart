import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/custom_dialog.dart';
import '../../../../../../core/components/text_input_field.dart';
import '../../../../../../core/components/theme/app_theme.dart';
import '../cubit/quiz_editor_cubit.dart';

class EditQuestionDialog extends StatefulWidget {
  final String initialValue;
  const EditQuestionDialog({super.key, required this.initialValue});

  @override
  State<EditQuestionDialog> createState() => _EditQuestionDialogState();
}

class _EditQuestionDialogState extends State<EditQuestionDialog> {
  late String value;
  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextInputField(
            onChanged: (e) => setState(() => value = e),
            initialValue: value,
            hint: context.translator.tapToModifyQuestion,
            showLabel: true,
          ),
          SizedBox(height: theme.spacing.medium),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(theme.good),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ))),
                onPressed: () {
                  context.read<QuizEditorCubit>().updateCurrentQuestionText(
                      newText: value.isEmpty ? null : value);
                  Navigator.pop(context);
                },
                child: Text(context.translator.save),
              ),
            ],
          )
        ],
      ),
    );
  }
}
