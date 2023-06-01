import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter/services.dart';
import 'package:testador/core/components/components.dart';
import 'package:testador/core/language_cubit/language_cubit.dart';
import 'package:testador/core/routing/app_router.gr.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/authentication/presentation/auth_bloc/auth_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final Widget? leading;
  final List<Widget>? trailing;
  final Widget? title;
  final PreferredSizeWidget? bottom;
  final Color fillColor;
  final Color? mainColor;
  final bool showPlay;
  const CustomAppBar({
    Key? key,
    this.showLeading = true,
    this.leading,
    this.trailing,
    this.title,
    this.bottom,
    this.fillColor = Colors.transparent,
    this.mainColor,
    this.showPlay = true,
  }) : super(key: key);

  AppBar theAppBar({
    required AppThemeData theme,
    VoidCallback? onMenuPressed,
    required BuildContext context,
  }) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: fillColor == Colors.transparent ? 0 : null,
      foregroundColor: mainColor ?? theme.primaryColor,
      automaticallyImplyLeading: showLeading && leading == null,
      leading: leading,
      title: title ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(color: mainColor ?? theme.primaryColor),
              const SizedBox(width: 10),
              Text(
                "Testador",
                style: TextStyle(
                  color: mainColor ?? theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      backgroundColor: fillColor,
      actions: trailing ??
          [
            if (showPlay)
              TextButton(
                  onPressed: () {
                    if (DeviceSize.isDesktopMode) {
                      context.navigateTo(const PlayerSessionManagerRoute());
                    } else {
                      context.pushRoute(const PlayerSessionManagerRoute());
                    }
                  },
                  child: Text(context.translator.play,
                      style: theme.actionTextStyle)),
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return LanguagePicker(
                  initialLanguage: state.locale,
                  languages: const {
                    "Deutsch": 'de',
                    "English": 'en',
                    "Français": 'fr',
                    "Magyar": 'hu',
                    'Русский': 'ru',
                    "Română": 'ro',
                    'Українська': 'uk',
                  },
                  onChanged: (newValue) {
                    if (newValue == null) return;
                    context.read<LanguageCubit>().update(newValue);
                  },
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticatedState) {
                  return IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthUserLoggedOut());
                      },
                      icon: const Icon(Icons.logout));
                }
                return Container();
              },
            ),
          ],
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return theAppBar(
      theme: theme,
      onMenuPressed: () => Scaffold.of(context).openEndDrawer(),
      context: context,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class LanguagePicker extends StatelessWidget {
  final String initialLanguage;
  final Map<String, String> languages;
  final void Function(String? newValue) onChanged;

  const LanguagePicker(
      {super.key,
      required this.initialLanguage,
      required this.languages,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: context.translator.language,
      onSelected: onChanged,
      itemBuilder: (BuildContext context) {
        return languages.keys.map((String choice) {
          return PopupMenuItem<String>(
            value: languages[choice] ?? 'en',
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
