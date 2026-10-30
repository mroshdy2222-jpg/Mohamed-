import 'dart:ui';

/// The app's languages. Arabic comes in three registers so people read the
/// app the way they speak: Egyptian, Gulf, and Standard Arabic.
enum AppLanguage {
  egyptian('ar', 'EG'),
  gulf('ar', 'SA'),
  standard('ar', null),
  english('en', null);

  final String languageCode;
  final String? countryCode;

  const AppLanguage(this.languageCode, this.countryCode);

  Locale get locale => Locale(languageCode, countryCode);
}

const _gulfCountries = {'SA', 'AE', 'KW', 'QA', 'BH', 'OM'};

/// The first-launch choice, from the phone's region. Egypt is the test market,
/// so a phone set to English in Egypt still starts in Egyptian Arabic; the
/// first onboarding question lets anyone switch.
AppLanguage defaultLanguage(Locale device) {
  final country = device.countryCode?.toUpperCase();
  if (country != null && _gulfCountries.contains(country)) return AppLanguage.gulf;
  if (device.languageCode == 'ar' && country != null && country != 'EG') return AppLanguage.standard;
  return AppLanguage.egyptian;
}
