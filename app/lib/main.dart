import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';
import 'data/store.dart';
import 'data/weather.dart';
import 'domain/languages.dart';
import 'l10n/app_localizations.dart';
import 'ui/home_shell.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(store: PrefsStore(), weatherService: WeatherService());
  // The wardrobe loads from the device before the first frame; the weather
  // arrives a moment later and updates the outfit when it does.
  final restored = state.restore();
  await Future.any([restored, Future.delayed(const Duration(milliseconds: 800))]);
  runApp(TallaApp(state: state));
}

class TallaApp extends StatelessWidget {
  final AppState state;

  /// The phone's locale, used until the user picks a language.
  final Locale? deviceLocale;

  const TallaApp({super.key, required this.state, this.deviceLocale});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final device = deviceLocale ?? WidgetsBinding.instance.platformDispatcher.locale;
        final language = state.profile.language ?? defaultLanguage(device);
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          home: HomeShell(state: state, language: language),
        );
      },
    );
  }
}
