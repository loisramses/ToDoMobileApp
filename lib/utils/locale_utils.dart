import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final ValueNotifier<Locale> localeNotifier =
    ValueNotifier(const Locale('pt', 'PT'));

final List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('pt', 'PT'),
  Locale('es', 'ES'),
];

final List<LocalizationsDelegate> localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
