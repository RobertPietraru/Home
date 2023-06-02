import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton(
      {super.key,
      required this.text,
      this.isEnabled = true,
      required this.onPressed,
      this.disabledColor = Colors.grey,
      this.enabledColor = Colors.green});

  final String text;
  final bool isEnabled;
  final VoidCallback onPressed;
  final Color enabledColor;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: theme.standardPadding,
      child: FilledButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                isEnabled ? enabledColor : disabledColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: isEnabled ? onPressed : null,
        child: Text(text),
      ),
    );
  }
}
