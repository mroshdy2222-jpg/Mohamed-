import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';
import 'l10n/app_localizations.dart';
import 'ui/home_shell.dart';
import 'ui/theme.dart';

void main() {
  runApp(TallaApp(state: AppState()));
}

class TallaApp extends StatefulWidget {
  final AppState state;
  final Locale initialLocale;

  const TallaApp({super.key, required this.state, this.initialLocale = const Locale('ar')});

  @override
  State<TallaApp> createState() => _TallaAppState();
}

class _TallaAppState extends State<TallaApp> {
  late Locale _locale = widget.initialLocale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: HomeShell(state: widget.state, locale: _locale, onLocale: (l) => setState(() => _locale = l)),
    );
  }
}
