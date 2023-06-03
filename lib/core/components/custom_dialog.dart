import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.radius = 20,
    required this.child,
    this.width,
  });

  final double radius;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: theme.defaultBackgroundColor,
        ),
        child: Padding(
          padding: theme.standardPadding,
          child: child,
        ),
      ),
    );
  }
}
