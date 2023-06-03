import 'package:flutter/material.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
import 'package:homeapp/core/utils/translator.dart';
import 'package:household/household.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/components/buttons/long_button.dart';

class InviteToHomeScreen extends StatelessWidget {
  final HomeEntity homeEntity;
  const InviteToHomeScreen({super.key, required this.homeEntity});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            Text(
              context.translator.homeIsWhere,
              style: theme.subtitleTextStyle,
              textAlign: TextAlign.end,
            ),
            Column(
              children: [
                LongButton(
                  label: context.translator.inviteYourFamily,
                  color: theme.companyColor,
                  onPressed: () async {
                    Share.share(homeEntity.id);
                    Navigator.pop(context);
                  },
                  isLoading: false,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(context.translator.later)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
