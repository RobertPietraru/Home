import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme_data.dart';

import '../theme/app_theme.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.isLoading,
    this.height = 55,
    this.color,
    this.error,
  }) : super(key: key);

  final String? error;
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final color = this.color ?? theme.primaryColor;
    return Column(
      children: [
        SizedBox(
          height: height,
          child: TextButton(
            onPressed: !isLoading ? onPressed : null,
            style: ButtonStyle(
              splashFactory: InkSplash.splashFactory,
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => theme.secondaryColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
              backgroundColor: MaterialStateColor.resolveWith(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return color.withOpacity(0.2);
                  }

                  return color;
                },
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  CircularProgressIndicator(
                    color: theme.defaultBackgroundColor,
                  )
                else
                  buildText(theme),
              ],
            ),
          ),
        ),
        if (error != null)
          Column(
            children: [
              SizedBox(height: theme.spacing.small),
              Text(
                error!,
                style: theme.informationTextStyle.copyWith(color: theme.bad),
              ),
            ],
          )
      ],
    );
  }

  Widget buildText(AppThemeData theme) {
    return Text(label,
        style: theme.subtitleTextStyle
            .copyWith(color: theme.defaultBackgroundColor));
  }
}
