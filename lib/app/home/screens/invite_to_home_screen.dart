import 'package:flutter/material.dart';
import 'package:homeapp/core/components/custom_app_bar.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';
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
              "“Home is where your loved ones are.” \n- My mom",
              style: theme.actionTextStyle,
              textAlign: TextAlign.end,
            ),
            Column(
              children: [
                LongButton(
                  label: "Invite your family",
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
                    child: const Text("Later")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
