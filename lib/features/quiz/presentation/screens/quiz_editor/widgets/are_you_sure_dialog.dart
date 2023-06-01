import 'package:flutter/material.dart';
import 'package:testador/core/components/custom_dialog.dart';
import 'package:testador/core/components/theme/app_theme.dart';

class AreYouSureDialog extends StatelessWidget {
  final String text;
  final String option1;
  final String option2;
  const AreYouSureDialog(
      {super.key,
      required this.text,
      required this.option1,
      required this.option2});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return CustomDialog(
        fitContent: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: theme.subtitleTextStyle),
            SizedBox(height: theme.spacing.medium),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(theme.bad),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ))),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(option1),
                ),
                SizedBox(width: theme.spacing.medium),
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(theme.good),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ))),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(option2),
                ),
              ],
            ),
          ],
        ));
  }
}
