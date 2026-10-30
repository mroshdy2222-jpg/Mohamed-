import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'طالا'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In ar, this message translates to:
  /// **'النهارده'**
  String get navToday;

  /// No description provided for @navWardrobe.
  ///
  /// In ar, this message translates to:
  /// **'الدولاب'**
  String get navWardrobe;

  /// No description provided for @navVote.
  ///
  /// In ar, this message translates to:
  /// **'التصويت'**
  String get navVote;

  /// No description provided for @navAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navAccount;

  /// No description provided for @todayTitle.
  ///
  /// In ar, this message translates to:
  /// **'طقم النهارده'**
  String get todayTitle;

  /// No description provided for @weatherLine.
  ///
  /// In ar, this message translates to:
  /// **'{temp}° {city}'**
  String weatherLine(int temp, String city);

  /// No description provided for @wearIt.
  ///
  /// In ar, this message translates to:
  /// **'هلبسه'**
  String get wearIt;

  /// No description provided for @dressMeAgain.
  ///
  /// In ar, this message translates to:
  /// **'لبّسني تاني'**
  String get dressMeAgain;

  /// No description provided for @askFriends.
  ///
  /// In ar, this message translates to:
  /// **'خد رأي صحابك'**
  String get askFriends;

  /// No description provided for @lockHint.
  ///
  /// In ar, this message translates to:
  /// **'دوس على قطعة عشان تقفلها'**
  String get lockHint;

  /// No description provided for @lockedLabel.
  ///
  /// In ar, this message translates to:
  /// **'مقفولة'**
  String get lockedLabel;

  /// No description provided for @noOutfit.
  ///
  /// In ar, this message translates to:
  /// **'مش لاقيين طقم مناسب'**
  String get noOutfit;

  /// No description provided for @noOutfitHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب ستايل تاني، أو ضيف قطع للدولاب، أو شوف لو حاجة في الغسيل.'**
  String get noOutfitHint;

  /// No description provided for @withWhomTitle.
  ///
  /// In ar, this message translates to:
  /// **'كنت مع مين؟'**
  String get withWhomTitle;

  /// No description provided for @withWhomHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، زي: عيلة ماما'**
  String get withWhomHint;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'سجّل'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @wornSaved.
  ///
  /// In ar, this message translates to:
  /// **'اتسجل في سجل اللبس'**
  String get wornSaved;

  /// No description provided for @wornBefore.
  ///
  /// In ar, this message translates to:
  /// **'لبست قطعة من الطقم ده قدام نفس الناس يوم {date}'**
  String wornBefore(String date);

  /// No description provided for @reasonNeutrals.
  ///
  /// In ar, this message translates to:
  /// **'ألوان محايدة كلها، اختيار آمن ونضيف.'**
  String get reasonNeutrals;

  /// No description provided for @reasonAccent.
  ///
  /// In ar, this message translates to:
  /// **'لون واحد بارز على ألوان هادية، فالطقم متوازن.'**
  String get reasonAccent;

  /// No description provided for @reasonMonochrome.
  ///
  /// In ar, this message translates to:
  /// **'درجات من نفس اللون، شكل متناسق ومرتب.'**
  String get reasonMonochrome;

  /// No description provided for @reasonAnalogous.
  ///
  /// In ar, this message translates to:
  /// **'لونين جيران على دايرة الألوان، فبيمشوا مع بعض بهدوء.'**
  String get reasonAnalogous;

  /// No description provided for @reasonComplementary.
  ///
  /// In ar, this message translates to:
  /// **'لونين عكس بعض، فالطقم لافت ومتوازن.'**
  String get reasonComplementary;

  /// No description provided for @reasonClash.
  ///
  /// In ar, this message translates to:
  /// **'ألوان جريئة مع بعض، لو حابب تلفت النظر.'**
  String get reasonClash;

  /// No description provided for @noteCold.
  ///
  /// In ar, this message translates to:
  /// **'ضفنا طبقة عشان الجو برد.'**
  String get noteCold;

  /// No description provided for @noteHot.
  ///
  /// In ar, this message translates to:
  /// **'قطع خفيفة عشان الجو حر.'**
  String get noteHot;

  /// No description provided for @wardrobeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدولاب'**
  String get wardrobeTitle;

  /// No description provided for @wardrobeCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} قطعة'**
  String wardrobeCount(int count);

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @statusLaundry.
  ///
  /// In ar, this message translates to:
  /// **'في الغسيل'**
  String get statusLaundry;

  /// No description provided for @statusLent.
  ///
  /// In ar, this message translates to:
  /// **'مسلّفة'**
  String get statusLent;

  /// No description provided for @statusAvailable.
  ///
  /// In ar, this message translates to:
  /// **'موجودة'**
  String get statusAvailable;

  /// No description provided for @emptyWardrobe.
  ///
  /// In ar, this message translates to:
  /// **'الدولاب فاضي. ابدأ بالأساسيات.'**
  String get emptyWardrobe;

  /// No description provided for @addBasics.
  ///
  /// In ar, this message translates to:
  /// **'ضيف الأساسيات'**
  String get addBasics;

  /// No description provided for @basicsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عندك الحاجات دي؟'**
  String get basicsTitle;

  /// No description provided for @basicsHint.
  ///
  /// In ar, this message translates to:
  /// **'دوس على اللي عندك، وتقدر تصوّرها بعدين.'**
  String get basicsHint;

  /// No description provided for @basicsDone.
  ///
  /// In ar, this message translates to:
  /// **'يلا نشوف طقم النهارده'**
  String get basicsDone;

  /// No description provided for @basicsSelected.
  ///
  /// In ar, this message translates to:
  /// **'{count} قطعة'**
  String basicsSelected(int count);

  /// No description provided for @genderQuestion.
  ///
  /// In ar, this message translates to:
  /// **'التطبيق ليك ولا ليكي؟'**
  String get genderQuestion;

  /// No description provided for @genderFemale.
  ///
  /// In ar, this message translates to:
  /// **'ستات'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In ar, this message translates to:
  /// **'رجالة'**
  String get genderMale;

  /// No description provided for @hijabQuestion.
  ///
  /// In ar, this message translates to:
  /// **'بتلبسي حجاب؟'**
  String get hijabQuestion;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'أيوه'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لأ'**
  String get no;

  /// No description provided for @cityLabel.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get cityLabel;

  /// No description provided for @voteTitle.
  ///
  /// In ar, this message translates to:
  /// **'ده ولا ده؟'**
  String get voteTitle;

  /// No description provided for @voteSoon.
  ///
  /// In ar, this message translates to:
  /// **'التصويت بلينك واتساب جاي في التحديث الجاي. لحد ما ييجي، رأي طالا بيظهر مع كل طقم.'**
  String get voteSoon;

  /// No description provided for @languageLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get languageLabel;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربي'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @occasionLabel.
  ///
  /// In ar, this message translates to:
  /// **'المناسبة'**
  String get occasionLabel;

  /// No description provided for @styleLabel.
  ///
  /// In ar, this message translates to:
  /// **'الستايل'**
  String get styleLabel;

  /// No description provided for @catTop.
  ///
  /// In ar, this message translates to:
  /// **'لبس علوي'**
  String get catTop;

  /// No description provided for @catBottom.
  ///
  /// In ar, this message translates to:
  /// **'لبس سفلي'**
  String get catBottom;

  /// No description provided for @catOnePiece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة واحدة'**
  String get catOnePiece;

  /// No description provided for @catOuterwear.
  ///
  /// In ar, this message translates to:
  /// **'جاكت'**
  String get catOuterwear;

  /// No description provided for @catShoes.
  ///
  /// In ar, this message translates to:
  /// **'جزم'**
  String get catShoes;

  /// No description provided for @catBag.
  ///
  /// In ar, this message translates to:
  /// **'شنط'**
  String get catBag;

  /// No description provided for @catHeadscarf.
  ///
  /// In ar, this message translates to:
  /// **'طرح'**
  String get catHeadscarf;

  /// No description provided for @catShemagh.
  ///
  /// In ar, this message translates to:
  /// **'شماغ'**
  String get catShemagh;

  /// No description provided for @catAccessory.
  ///
  /// In ar, this message translates to:
  /// **'إكسسوارات'**
  String get catAccessory;

  /// No description provided for @styleLounge.
  ///
  /// In ar, this message translates to:
  /// **'بيتي'**
  String get styleLounge;

  /// No description provided for @styleSport.
  ///
  /// In ar, this message translates to:
  /// **'رياضي'**
  String get styleSport;

  /// No description provided for @styleCasual.
  ///
  /// In ar, this message translates to:
  /// **'كاجوال'**
  String get styleCasual;

  /// No description provided for @styleDrip.
  ///
  /// In ar, this message translates to:
  /// **'دريب'**
  String get styleDrip;

  /// No description provided for @styleSmartCasual.
  ///
  /// In ar, this message translates to:
  /// **'سمارت كاجوال'**
  String get styleSmartCasual;

  /// No description provided for @styleFormal.
  ///
  /// In ar, this message translates to:
  /// **'فورمال'**
  String get styleFormal;

  /// No description provided for @styleDressy.
  ///
  /// In ar, this message translates to:
  /// **'دريسي'**
  String get styleDressy;

  /// No description provided for @styleTraditional.
  ///
  /// In ar, this message translates to:
  /// **'تراثي'**
  String get styleTraditional;

  /// No description provided for @occUniversity.
  ///
  /// In ar, this message translates to:
  /// **'جامعة'**
  String get occUniversity;

  /// No description provided for @occWork.
  ///
  /// In ar, this message translates to:
  /// **'شغل'**
  String get occWork;

  /// No description provided for @occOuting.
  ///
  /// In ar, this message translates to:
  /// **'خروجة'**
  String get occOuting;

  /// No description provided for @occDate.
  ///
  /// In ar, this message translates to:
  /// **'موعد'**
  String get occDate;

  /// No description provided for @occInterview.
  ///
  /// In ar, this message translates to:
  /// **'مقابلة شغل'**
  String get occInterview;

  /// No description provided for @occWedding.
  ///
  /// In ar, this message translates to:
  /// **'فرح'**
  String get occWedding;

  /// No description provided for @occEngagement.
  ///
  /// In ar, this message translates to:
  /// **'خطوبة'**
  String get occEngagement;

  /// No description provided for @occEid.
  ///
  /// In ar, this message translates to:
  /// **'عيد'**
  String get occEid;

  /// No description provided for @occHome.
  ///
  /// In ar, this message translates to:
  /// **'البيت'**
  String get occHome;

  /// No description provided for @occGym.
  ///
  /// In ar, this message translates to:
  /// **'جيم'**
  String get occGym;

  /// No description provided for @occParty.
  ///
  /// In ar, this message translates to:
  /// **'حفلة'**
  String get occParty;

  /// No description provided for @colWhite.
  ///
  /// In ar, this message translates to:
  /// **'أبيض'**
  String get colWhite;

  /// No description provided for @colCream.
  ///
  /// In ar, this message translates to:
  /// **'أوف وايت'**
  String get colCream;

  /// No description provided for @colBlack.
  ///
  /// In ar, this message translates to:
  /// **'أسود'**
  String get colBlack;

  /// No description provided for @colGrey.
  ///
  /// In ar, this message translates to:
  /// **'رمادي'**
  String get colGrey;

  /// No description provided for @colNavy.
  ///
  /// In ar, this message translates to:
  /// **'كحلي'**
  String get colNavy;

  /// No description provided for @colDenim.
  ///
  /// In ar, this message translates to:
  /// **'جينز'**
  String get colDenim;

  /// No description provided for @colBeige.
  ///
  /// In ar, this message translates to:
  /// **'بيج'**
  String get colBeige;

  /// No description provided for @colCamel.
  ///
  /// In ar, this message translates to:
  /// **'كاميل'**
  String get colCamel;

  /// No description provided for @colBrown.
  ///
  /// In ar, this message translates to:
  /// **'بني'**
  String get colBrown;

  /// No description provided for @colOlive.
  ///
  /// In ar, this message translates to:
  /// **'زيتوني'**
  String get colOlive;

  /// No description provided for @colKhaki.
  ///
  /// In ar, this message translates to:
  /// **'كاكي'**
  String get colKhaki;

  /// No description provided for @colRed.
  ///
  /// In ar, this message translates to:
  /// **'أحمر'**
  String get colRed;

  /// No description provided for @colBurgundy.
  ///
  /// In ar, this message translates to:
  /// **'عنابي'**
  String get colBurgundy;

  /// No description provided for @colPink.
  ///
  /// In ar, this message translates to:
  /// **'بمبي'**
  String get colPink;

  /// No description provided for @colBlush.
  ///
  /// In ar, this message translates to:
  /// **'روز'**
  String get colBlush;

  /// No description provided for @colOrange.
  ///
  /// In ar, this message translates to:
  /// **'برتقاني'**
  String get colOrange;

  /// No description provided for @colMustard.
  ///
  /// In ar, this message translates to:
  /// **'مستردة'**
  String get colMustard;

  /// No description provided for @colYellow.
  ///
  /// In ar, this message translates to:
  /// **'أصفر'**
  String get colYellow;

  /// No description provided for @colGreen.
  ///
  /// In ar, this message translates to:
  /// **'أخضر'**
  String get colGreen;

  /// No description provided for @colEmerald.
  ///
  /// In ar, this message translates to:
  /// **'زمردي'**
  String get colEmerald;

  /// No description provided for @colTeal.
  ///
  /// In ar, this message translates to:
  /// **'تيل'**
  String get colTeal;

  /// No description provided for @colSky.
  ///
  /// In ar, this message translates to:
  /// **'لبني'**
  String get colSky;

  /// No description provided for @colBlue.
  ///
  /// In ar, this message translates to:
  /// **'أزرق'**
  String get colBlue;

  /// No description provided for @colLavender.
  ///
  /// In ar, this message translates to:
  /// **'لافندر'**
  String get colLavender;

  /// No description provided for @colPurple.
  ///
  /// In ar, this message translates to:
  /// **'بنفسجي'**
  String get colPurple;

  /// No description provided for @cityCairo.
  ///
  /// In ar, this message translates to:
  /// **'القاهرة'**
  String get cityCairo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
