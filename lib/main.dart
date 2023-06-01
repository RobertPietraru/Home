import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testador/core/language_cubit/language_cubit.dart';
import 'package:testador/core/routing/app_router.dart';
import 'package:testador/features/quiz/data/dtos/question/question_dto.dart';
import 'package:testador/features/quiz/data/dtos/quiz/quiz_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/components/theme/app_theme.dart';
import '../core/components/theme/app_theme_data.dart';
import '../features/authentication/presentation/widgets/auth_bloc_wrapper.dart';
import '../features/quiz/data/dtos/draft/draft_dto.dart';
import '../injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// make sure the filename doesn't start with a dot or the app won't run on the web
  await dotenv.load(fileName: "dotenv.env");
  OpenAI.apiKey = dotenv.env['OPEN_AI_API_KEY']!;
  await Hive.initFlutter();
  Hive.registerAdapter(QuizDtoAdapter());
  Hive.registerAdapter(DraftDtoAdapter());
  Hive.registerAdapter(QuestionDtoAdapter());
  Hive.registerAdapter(MultipleChoiceOptionDtoAdapter());
  (await Hive.openBox<QuizDto>(QuizDto.collection));
  (await Hive.openBox<DraftDto>(DraftDto.hiveBoxName));
  await initialize();

  runApp(const AuthBlocWidget(child: MyApp()));
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
  late AppRouter _appRouter;

  @override
  void initState() {
    _appRouter = AppRouter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: Builder(builder: (context) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return AppTheme(
              lightTheme: _lightTheme,
              darkTheme: _darkTheme,
              child: Builder(builder: (context) {
                return MaterialApp.router(
                  routerConfig: _appRouter.config(),
                  theme: _lightTheme.materialThemeData(context),
                  darkTheme: _darkTheme.materialThemeData(context),
                  themeMode: ThemeMode.light,
                  locale: Locale(state.locale),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  // localizationsDelegates: [ AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, ],
                );
              }),
            );
          },
        );
      }),
    );
  }
}
