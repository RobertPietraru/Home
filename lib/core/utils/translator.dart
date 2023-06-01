import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef Translator = AppLocalizations;

extension X on BuildContext {
  AppLocalizations get translator {
    return AppLocalizations.of(this);
  }
}
