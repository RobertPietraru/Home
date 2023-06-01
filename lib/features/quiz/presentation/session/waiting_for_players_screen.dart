import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/custom_app_bar.dart';
import 'package:testador/core/utils/split_string_into_blocks.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/admin/session_admin_cubit/session_admin_cubit.dart';

import '../../../../core/components/buttons/app_bar_button.dart';
import '../../../../core/components/theme/app_theme.dart';
import '../../../../core/components/theme/device_size.dart';

class WaitingForPlayersScreen extends StatelessWidget {
  final SessionEntity session;
  final VoidCallback? onBegin;
  const WaitingForPlayersScreen(
      {super.key, required this.session, this.onBegin});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        trailing: [
          if (onBegin != null)
            AppBarButton(
              isEnabled: session.students.isNotEmpty,
              onPressed: onBegin!,
              text: context.translator.start,
            )
        ],
      ),
      body: Padding(
        padding: theme.standardPadding,
        child: Column(children: [
          Text(context.translator.sessionIsCreated,
              style: theme.titleTextStyle, textAlign: TextAlign.center),
          SizedBox(height: theme.spacing.large),
          Card(
            elevation: 25,
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onLongPress: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.translator.codeCopied)));
                await Clipboard.setData(ClipboardData(text: session.id));
              },
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.translator.codeCopied)));
                await Clipboard.setData(ClipboardData(text: session.id));
              },
              child: Ink(
                padding: theme.standardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.translator.password, style: theme.informationTextStyle),
                    SizedBox(height: theme.spacing.small),
                    Text(splitStringIntoBlocks(session.id),
                        style: theme.titleTextStyle),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.xxLarge),
          Expanded(
              child: Center(
            child: session.students.isEmpty
                ? Text("${context.translator.waitingForStudents}...", style: theme.titleTextStyle)
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: DeviceSize.screenHeight ~/ 300,
                        childAspectRatio: 3,
                        crossAxisSpacing: 2),
                    itemCount: session.students.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            //TODO: remove player
                          },
                          child: Ink(
                            child: Center(
                                child: Text(session.students[index].name)),
                          ),
                        ),
                      );
                    },
                  ),
          )),
        ]),
      ),
    );
  }
}
