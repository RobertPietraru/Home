import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testador/core/utils/translator.dart';

import '../../../../../../core/components/theme/app_theme.dart';
import '../../../../../../core/utils/split_string_into_blocks.dart';

class SessionCodeWidget extends StatelessWidget {
  final String sessionId;
  const SessionCodeWidget({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
        onLongPress: () async {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.translator.codeCopied)));
          await Clipboard.setData(ClipboardData(text: sessionId));
        },
        onTap: () async {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.translator.codeCopied)));
          await Clipboard.setData(ClipboardData(text: sessionId));
        },
        child: Text(splitStringIntoBlocks(sessionId),
            style: theme.titleTextStyle));
  }
}
