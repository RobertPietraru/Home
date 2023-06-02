import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _dividerThemeData = DividerThemeData(
  space: 0,
);

// If the number of properties get too big, we can start grouping them in
// classes like Flutter does with TextTheme, ButtonTheme, etc, inside ThemeData.
abstract class AppThemeData {
  ThemeData materialThemeData(BuildContext context);

  Color getColor(int index) {
    return [
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.purple
    ][index];
  }

  TextStyle get questionTextStyle => subtitleTextStyle;

  String get placeholderImage =>
      'https://www.parentmap.com/images/article/7793/iStock_000043382420_Large.jpg';

  final ThemeSpacing spacing = ThemeSpacing();

  Color get defaultBackgroundColor;
  Color get primaryColor;
  Color get secondaryColor;
  Color get companyColor => Colors.green;

  Color get bad => Colors.red;
  Color get good => Colors.green;

  EdgeInsets get standardPadding => EdgeInsets.symmetric(
      horizontal: spacing.xLarge, vertical: spacing.xLarge);

  TextStyle largetitleTextStyle = const TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
  );
  TextStyle titleTextStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  TextStyle actionTextStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  TextStyle subtitleTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  TextStyle informationTextStyle = const TextStyle(
    fontSize: 18,
  );
}

class LightAppThemeData extends AppThemeData {
  @override
  ThemeData materialThemeData(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        primarySwatch: primaryColor.toMaterialColor(),
        dividerTheme: _dividerThemeData,
      );

  @override
  Color get defaultBackgroundColor => Colors.white;

  @override
  Color get primaryColor => Colors.black;

  @override
  Color get secondaryColor => Colors.grey;
}

class DarkAppThemeData extends AppThemeData {
  @override
  ThemeData materialThemeData(BuildContext context) => ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
      ),
      listTileTheme: ListTileThemeData(
        textColor: primaryColor,
      ),
      textTheme:
          GoogleFonts.interTextTheme(Theme.of(context).textTheme.copyWith(
                bodyLarge: TextStyle(color: primaryColor),
                bodyMedium: TextStyle(color: primaryColor),
                displayLarge: TextStyle(color: primaryColor),
                displayMedium: TextStyle(color: primaryColor),
                displaySmall: TextStyle(color: primaryColor),
                headlineMedium: TextStyle(color: primaryColor),
                headlineSmall: TextStyle(color: primaryColor),
                titleLarge: TextStyle(color: primaryColor),
                titleMedium: TextStyle(color: primaryColor),
                titleSmall: TextStyle(color: primaryColor),
                labelLarge: TextStyle(color: primaryColor),
                bodySmall: TextStyle(color: primaryColor),
                labelSmall: TextStyle(color: primaryColor),
              )),
      brightness: Brightness.dark,
      dividerColor: primaryColor,
      primarySwatch: primaryColor.toMaterialColor(),
      dividerTheme: _dividerThemeData,
      scaffoldBackgroundColor: defaultBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: defaultBackgroundColor,
      ));

  @override
  Color get defaultBackgroundColor => const Color.fromARGB(255, 39, 39, 39);

  @override
  Color get primaryColor => Colors.white;

  @override
  Color get secondaryColor => Colors.grey[500]!;
}

extension on Color {
  Map<int, Color> _toSwatch() => {
        50: withOpacity(0.1),
        100: withOpacity(0.2),
        200: withOpacity(0.3),
        300: withOpacity(0.4),
        400: withOpacity(0.5),
        500: withOpacity(0.6),
        600: withOpacity(0.7),
        700: withOpacity(0.8),
        800: withOpacity(0.9),
        900: this,
      };

  MaterialColor toMaterialColor() => MaterialColor(
        value,
        _toSwatch(),
      );
}

class ThemeSpacing {
  final double xSmall = 4;
  final double small = 8;
  final double medium = 12;
  final double mediumLarge = 16;
  final double large = 20;
  final double xLarge = 24;
  final double xxLarge = 48;
  final double xxxLarge = 64;
}
