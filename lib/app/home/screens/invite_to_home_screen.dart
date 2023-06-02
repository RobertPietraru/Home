import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pietrocka_home/core/presentation/navigation/navigation_cubit.dart';
import 'package:pietrocka_home/core/presentation/widgets/buttons/long_button.dart';
import 'package:pietrocka_home/features/tasks/domain/entities/home_entity.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/global/styles.dart';
import '../../../../core/presentation/widgets/pietrocka_logo.dart';

class InviteToHomeScreen extends StatelessWidget {
  final HomeEntity homeEntity;
  const InviteToHomeScreen({super.key, required this.homeEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.read<NavigationCubit>().pop(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const PietrockaLogo(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            const Text(
              "“Home is where your loved ones are.” \n- My mom",
              style: Styles.titleStyle1,
              textAlign: TextAlign.end,
            ),
            Column(
              children: [
                LongButton(
                    text: "Invite your family",
                    onPressed: () async {
                      Share.share(homeEntity.id);
                      Navigator.pop(context);
                    }),
                TextButton(
                    onPressed: () {
                      context.read<NavigationCubit>().pop(context);
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
