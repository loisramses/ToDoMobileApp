import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_app/utils/locale.dart';

void main() {
  initializeDateFormatting().then(
    (_) => runApp(
      ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, child) {
          return MyApp(
            locale: locale,
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
