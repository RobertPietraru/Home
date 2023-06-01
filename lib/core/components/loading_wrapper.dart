import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testador/core/components/theme/app_theme.dart';

class LoadingWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool showIndicator;
  const LoadingWrapper(
      {super.key,
      required this.child,
      required this.isLoading,
      this.showIndicator = true});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      children: [
        child,
        if (isLoading)
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                  color: theme.defaultBackgroundColor.withOpacity(0.7),
                  child: const Center(child: CircularProgressIndicator()))),
      ],
    );
  }
}
