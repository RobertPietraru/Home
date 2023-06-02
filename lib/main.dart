import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:homeapp/app/auth/registration/registration_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/components/theme/app_theme.dart';
import '../core/components/theme/app_theme_data.dart';
import '../injection.dart';
import 'core/blocs/auth_bloc/auth_bloc.dart';
import 'core/blocs/language_cubit/language_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initialize();

  runApp(BlocProvider(
      create: (context) => AuthBloc(locator()), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _lightTheme = LightAppThemeData();
  final _darkTheme = DarkAppThemeData();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: Builder(builder: (context) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, localeState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return AppTheme(
                  lightTheme: _lightTheme,
                  darkTheme: _darkTheme,
                  child: Builder(builder: (context) {
                    return MaterialApp(
                      home: () {
                        switch (state.runtimeType) {
                          case AuthAuthenticatedState:
                            return Scaffold(
                                body: Center(
                                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Logged in'),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(const AuthUserLoggedOut());
                                  },
                                  child: Text("Logout"),
                                ),
                                Text('asdf')
                              ],
                            )));
                          case AuthUnauthenticatedState:
                            return RegistrationScreen();
                          case AuthFailureState:
                            return const Text('aasdf');
                          default:
                            return const Scaffold(
                                body: Center(
                              child: CircularProgressIndicator(),
                            ));
                        }
                      }(),
                      theme: _lightTheme.materialThemeData(context),
                      darkTheme: _darkTheme.materialThemeData(context),
                      themeMode: ThemeMode.light,
                      locale: Locale(localeState.locale),
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      // localizationsDelegates: [ AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, ],
                    );
                  }),
                );
              },
            );
          },
        );
      }),
    );
  }
}
