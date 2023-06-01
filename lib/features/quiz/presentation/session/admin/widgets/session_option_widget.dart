import 'package:flutter/material.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/theme/app_theme.dart';
import '../../../../domain/entities/question_entity.dart';

class SessionOptionWidget extends StatefulWidget {
  final int index;
  final MultipleChoiceOptionEntity option;
  final VoidCallback? onPressed;
  final bool isSelected;
  const SessionOptionWidget({
    super.key,
    required this.index,
    required this.option,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<SessionOptionWidget> createState() => _SessionOptionWidgetState();
}

class _SessionOptionWidgetState extends State<SessionOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.option.text != null;
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: widget.onPressed,
        child: Ink(
          color:
              isEnabled ? theme.getColor(widget.index) : theme.secondaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.isSelected)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(Icons.done, color: Colors.black)),
                    )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.option.text ?? "${context.translator.option} ${widget.index + 1}",
                    style: theme.questionTextStyle,
                  ),
                ),
              ),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
