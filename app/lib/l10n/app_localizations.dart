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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('ar', 'EG'),
    Locale('ar', 'SA'),
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
  /// **'اليوم'**
  String get navToday;

  /// No description provided for @navWardrobe.
  ///
  /// In ar, this message translates to:
  /// **'الخزانة'**
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
  /// **'إطلالة اليوم'**
  String get todayTitle;

  /// No description provided for @weatherLine.
  ///
  /// In ar, this message translates to:
  /// **'{temp}° {city}'**
  String weatherLine(int temp, String city);

  /// No description provided for @wearIt.
  ///
  /// In ar, this message translates to:
  /// **'سأختاره'**
  String get wearIt;

  /// No description provided for @dressMeAgain.
  ///
  /// In ar, this message translates to:
  /// **'اختيار آخر'**
  String get dressMeAgain;

  /// No description provided for @askFriends.
  ///
  /// In ar, this message translates to:
  /// **'اسأل أصدقاءك'**
  String get askFriends;

  /// No description provided for @lockHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على قطعة لتثبيتها'**
  String get lockHint;

  /// No description provided for @lockedLabel.
  ///
  /// In ar, this message translates to:
  /// **'مثبّتة'**
  String get lockedLabel;

  /// No description provided for @noOutfit.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد إطلالة مناسبة'**
  String get noOutfit;

  /// No description provided for @noOutfitHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب أسلوبًا آخر، أو أضف قطعًا إلى الخزانة، أو تحقّق مما في الغسيل.'**
  String get noOutfitHint;

  /// No description provided for @withWhomTitle.
  ///
  /// In ar, this message translates to:
  /// **'مع من كنت؟'**
  String get withWhomTitle;

  /// No description provided for @withWhomHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، مثل: عائلة أمي'**
  String get withWhomHint;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @wornSaved.
  ///
  /// In ar, this message translates to:
  /// **'سُجّلت في سجل الملابس'**
  String get wornSaved;

  /// No description provided for @wornBefore.
  ///
  /// In ar, this message translates to:
  /// **'ارتديت قطعة من هذه الإطلالة أمام الأشخاص أنفسهم يوم {date}'**
  String wornBefore(String date);

  /// No description provided for @reasonNeutrals.
  ///
  /// In ar, this message translates to:
  /// **'ألوان محايدة بالكامل، اختيار آمن وأنيق.'**
  String get reasonNeutrals;

  /// No description provided for @reasonAccent.
  ///
  /// In ar, this message translates to:
  /// **'لون واحد بارز على ألوان هادئة، فتبدو الإطلالة متوازنة.'**
  String get reasonAccent;

  /// No description provided for @reasonMonochrome.
  ///
  /// In ar, this message translates to:
  /// **'درجات من اللون نفسه، مظهر متناسق ومرتب.'**
  String get reasonMonochrome;

  /// No description provided for @reasonAnalogous.
  ///
  /// In ar, this message translates to:
  /// **'لونان متجاوران في دائرة الألوان، يتناغمان بهدوء.'**
  String get reasonAnalogous;

  /// No description provided for @reasonComplementary.
  ///
  /// In ar, this message translates to:
  /// **'لونان متقابلان، فالإطلالة لافتة ومتوازنة.'**
  String get reasonComplementary;

  /// No description provided for @reasonClash.
  ///
  /// In ar, this message translates to:
  /// **'ألوان جريئة معًا، إن أردت لفت الأنظار.'**
  String get reasonClash;

  /// No description provided for @noteCold.
  ///
  /// In ar, this message translates to:
  /// **'أضفنا طبقة لأن الجو بارد.'**
  String get noteCold;

  /// No description provided for @noteHot.
  ///
  /// In ar, this message translates to:
  /// **'قطع خفيفة لأن الجو حار.'**
  String get noteHot;

  /// No description provided for @wardrobeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخزانة'**
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
  /// **'مُعارة'**
  String get statusLent;

  /// No description provided for @statusAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متاحة'**
  String get statusAvailable;

  /// No description provided for @emptyWardrobe.
  ///
  /// In ar, this message translates to:
  /// **'الخزانة فارغة. ابدأ بالأساسيات.'**
  String get emptyWardrobe;

  /// No description provided for @addBasics.
  ///
  /// In ar, this message translates to:
  /// **'أضف الأساسيات'**
  String get addBasics;

  /// No description provided for @basicsTitle.
  ///
  /// In ar, this message translates to:
  /// **'هل تملك هذه القطع؟'**
  String get basicsTitle;

  /// No description provided for @basicsHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على ما تملكه، ويمكنك تصويره لاحقًا.'**
  String get basicsHint;

  /// No description provided for @basicsDone.
  ///
  /// In ar, this message translates to:
  /// **'لنرَ إطلالة اليوم'**
  String get basicsDone;

  /// No description provided for @basicsSelected.
  ///
  /// In ar, this message translates to:
  /// **'{count} قطعة'**
  String basicsSelected(int count);

  /// No description provided for @genderQuestion.
  ///
  /// In ar, this message translates to:
  /// **'لمن هذا التطبيق؟'**
  String get genderQuestion;

  /// No description provided for @genderFemale.
  ///
  /// In ar, this message translates to:
  /// **'نساء'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In ar, this message translates to:
  /// **'رجال'**
  String get genderMale;

  /// No description provided for @hijabQuestion.
  ///
  /// In ar, this message translates to:
  /// **'هل ترتدين الحجاب؟'**
  String get hijabQuestion;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @cityLabel.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get cityLabel;

  /// No description provided for @voteTitle.
  ///
  /// In ar, this message translates to:
  /// **'هذا أم ذاك؟'**
  String get voteTitle;

  /// No description provided for @languageLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get languageLabel;

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
  /// **'الأسلوب'**
  String get styleLabel;

  /// No description provided for @catTop.
  ///
  /// In ar, this message translates to:
  /// **'ملابس علوية'**
  String get catTop;

  /// No description provided for @catBottom.
  ///
  /// In ar, this message translates to:
  /// **'ملابس سفلية'**
  String get catBottom;

  /// No description provided for @catOnePiece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة واحدة'**
  String get catOnePiece;

  /// No description provided for @catOuterwear.
  ///
  /// In ar, this message translates to:
  /// **'سترات'**
  String get catOuterwear;

  /// No description provided for @catShoes.
  ///
  /// In ar, this message translates to:
  /// **'أحذية'**
  String get catShoes;

  /// No description provided for @catBag.
  ///
  /// In ar, this message translates to:
  /// **'حقائب'**
  String get catBag;

  /// No description provided for @catHeadscarf.
  ///
  /// In ar, this message translates to:
  /// **'أوشحة'**
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
  /// **'عمل'**
  String get occWork;

  /// No description provided for @occOuting.
  ///
  /// In ar, this message translates to:
  /// **'نزهة'**
  String get occOuting;

  /// No description provided for @occDate.
  ///
  /// In ar, this message translates to:
  /// **'موعد'**
  String get occDate;

  /// No description provided for @occInterview.
  ///
  /// In ar, this message translates to:
  /// **'مقابلة عمل'**
  String get occInterview;

  /// No description provided for @occWedding.
  ///
  /// In ar, this message translates to:
  /// **'حفل زفاف'**
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
  /// **'المنزل'**
  String get occHome;

  /// No description provided for @occGym.
  ///
  /// In ar, this message translates to:
  /// **'نادٍ رياضي'**
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
  /// **'عاجي'**
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
  /// **'وردي'**
  String get colPink;

  /// No description provided for @colBlush.
  ///
  /// In ar, this message translates to:
  /// **'وردي فاتح'**
  String get colBlush;

  /// No description provided for @colOrange.
  ///
  /// In ar, this message translates to:
  /// **'برتقالي'**
  String get colOrange;

  /// No description provided for @colMustard.
  ///
  /// In ar, this message translates to:
  /// **'خردلي'**
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
  /// **'أزرق مخضر'**
  String get colTeal;

  /// No description provided for @colSky.
  ///
  /// In ar, this message translates to:
  /// **'سماوي'**
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

  /// No description provided for @addItem.
  ///
  /// In ar, this message translates to:
  /// **'أضف قطعة'**
  String get addItem;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In ar, this message translates to:
  /// **'من المعرض'**
  String get fromGallery;

  /// No description provided for @photoOptional.
  ///
  /// In ar, this message translates to:
  /// **'الصورة اختيارية. صوّر القطعة وحدها على سرير أو علّاقة.'**
  String get photoOptional;

  /// No description provided for @categoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get categoryLabel;

  /// No description provided for @colorLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللون'**
  String get colorLabel;

  /// No description provided for @stylesLabel.
  ///
  /// In ar, this message translates to:
  /// **'ما الأساليب التي تناسبها؟'**
  String get stylesLabel;

  /// No description provided for @seasonLabel.
  ///
  /// In ar, this message translates to:
  /// **'الموسم'**
  String get seasonLabel;

  /// No description provided for @seasonSummer.
  ///
  /// In ar, this message translates to:
  /// **'صيفي'**
  String get seasonSummer;

  /// No description provided for @seasonWinter.
  ///
  /// In ar, this message translates to:
  /// **'شتوي'**
  String get seasonWinter;

  /// No description provided for @seasonAll.
  ///
  /// In ar, this message translates to:
  /// **'كل المواسم'**
  String get seasonAll;

  /// No description provided for @patternLabel.
  ///
  /// In ar, this message translates to:
  /// **'النقشة'**
  String get patternLabel;

  /// No description provided for @patternSolid.
  ///
  /// In ar, this message translates to:
  /// **'سادة'**
  String get patternSolid;

  /// No description provided for @patternStriped.
  ///
  /// In ar, this message translates to:
  /// **'مقلّم'**
  String get patternStriped;

  /// No description provided for @patternChecked.
  ///
  /// In ar, this message translates to:
  /// **'مربعات'**
  String get patternChecked;

  /// No description provided for @patternPrinted.
  ///
  /// In ar, this message translates to:
  /// **'مطبوع'**
  String get patternPrinted;

  /// No description provided for @saveItem.
  ///
  /// In ar, this message translates to:
  /// **'أضفها إلى الخزانة'**
  String get saveItem;

  /// No description provided for @itemAdded.
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت القطعة'**
  String get itemAdded;

  /// No description provided for @deleteItem.
  ///
  /// In ar, this message translates to:
  /// **'احذفها من الخزانة'**
  String get deleteItem;

  /// No description provided for @cityAlexandria.
  ///
  /// In ar, this message translates to:
  /// **'الإسكندرية'**
  String get cityAlexandria;

  /// No description provided for @cityRiyadh.
  ///
  /// In ar, this message translates to:
  /// **'الرياض'**
  String get cityRiyadh;

  /// No description provided for @cityJeddah.
  ///
  /// In ar, this message translates to:
  /// **'جدة'**
  String get cityJeddah;

  /// No description provided for @cityDubai.
  ///
  /// In ar, this message translates to:
  /// **'دبي'**
  String get cityDubai;

  /// No description provided for @cityAbuDhabi.
  ///
  /// In ar, this message translates to:
  /// **'أبوظبي'**
  String get cityAbuDhabi;

  /// No description provided for @cityKuwait.
  ///
  /// In ar, this message translates to:
  /// **'الكويت'**
  String get cityKuwait;

  /// No description provided for @cityDoha.
  ///
  /// In ar, this message translates to:
  /// **'الدوحة'**
  String get cityDoha;

  /// No description provided for @arabicEgyptian.
  ///
  /// In ar, this message translates to:
  /// **'مصري'**
  String get arabicEgyptian;

  /// No description provided for @arabicGulf.
  ///
  /// In ar, this message translates to:
  /// **'خليجي'**
  String get arabicGulf;

  /// No description provided for @arabicStandard.
  ///
  /// In ar, this message translates to:
  /// **'فصحى'**
  String get arabicStandard;

  /// No description provided for @pollIntro.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ صورة فيها إطلالتان وأرسلها لأصدقائك على واتساب، ليردّوا بالرقم 1 أو 2.'**
  String get pollIntro;

  /// No description provided for @newPoll.
  ///
  /// In ar, this message translates to:
  /// **'تصويت جديد'**
  String get newPoll;

  /// No description provided for @sendPoll.
  ///
  /// In ar, this message translates to:
  /// **'أرسلها لأصدقائك'**
  String get sendPoll;

  /// No description provided for @swapOption.
  ///
  /// In ar, this message translates to:
  /// **'غيّر الإطلالة 2'**
  String get swapOption;

  /// No description provided for @replyWithNumber.
  ///
  /// In ar, this message translates to:
  /// **'ردّ بالرقم 1 أو 2'**
  String get replyWithNumber;

  /// No description provided for @shareText.
  ///
  /// In ar, this message translates to:
  /// **'أيهما أفضل؟ المناسبة: {occasion}. ردّ بالرقم 1 أو 2.'**
  String shareText(String occasion);

  /// No description provided for @whoWon.
  ///
  /// In ar, this message translates to:
  /// **'أيهما فاز؟'**
  String get whoWon;

  /// No description provided for @optionLabel.
  ///
  /// In ar, this message translates to:
  /// **'إطلالة {n}'**
  String optionLabel(int n);

  /// No description provided for @winnerLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفائز'**
  String get winnerLabel;

  /// No description provided for @noPolls.
  ///
  /// In ar, this message translates to:
  /// **'لم تنشئ أي تصويت بعد.'**
  String get noPolls;

  /// No description provided for @pollNeedsMore.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج إلى قطع أكثر لتكوين إطلالتين مختلفتين.'**
  String get pollNeedsMore;

  /// No description provided for @pollsHistory.
  ///
  /// In ar, this message translates to:
  /// **'تصويتاتك'**
  String get pollsHistory;

  /// No description provided for @missingTitle.
  ///
  /// In ar, this message translates to:
  /// **'ما الذي ينقصك؟'**
  String get missingTitle;

  /// No description provided for @missingGain.
  ///
  /// In ar, this message translates to:
  /// **'لو كانت لديك {item} لكوّنت {count} إطلالة إضافية بأسلوب {style}.'**
  String missingGain(String item, int count, String style);

  /// No description provided for @iHaveIt.
  ///
  /// In ar, this message translates to:
  /// **'أملكها'**
  String get iHaveIt;

  /// No description provided for @missingNone.
  ///
  /// In ar, this message translates to:
  /// **'خزانتك مكتملة في هذا الأسلوب.'**
  String get missingNone;

  /// No description provided for @tagging.
  ///
  /// In ar, this message translates to:
  /// **'تتعرّف طالا على القطعة…'**
  String get tagging;

  /// No description provided for @tagged.
  ///
  /// In ar, this message translates to:
  /// **'اقترحت طالا التفاصيل، راجعها قبل الإضافة.'**
  String get tagged;

  /// No description provided for @tagPerson.
  ///
  /// In ar, this message translates to:
  /// **'صوّر القطعة وحدها، دون أن يرتديها أحد.'**
  String get tagPerson;

  /// No description provided for @tagFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التعرّف عليها، اختر التفاصيل بنفسك.'**
  String get tagFailed;

  /// No description provided for @catBelt.
  ///
  /// In ar, this message translates to:
  /// **'حزام'**
  String get catBelt;

  /// No description provided for @catWatch.
  ///
  /// In ar, this message translates to:
  /// **'ساعة'**
  String get catWatch;

  /// No description provided for @catJewelry.
  ///
  /// In ar, this message translates to:
  /// **'مجوهرات'**
  String get catJewelry;

  /// No description provided for @catSunglasses.
  ///
  /// In ar, this message translates to:
  /// **'نظارة شمسية'**
  String get catSunglasses;

  /// No description provided for @catPerfume.
  ///
  /// In ar, this message translates to:
  /// **'عطر'**
  String get catPerfume;

  /// No description provided for @colGold.
  ///
  /// In ar, this message translates to:
  /// **'ذهبي'**
  String get colGold;

  /// No description provided for @colSilver.
  ///
  /// In ar, this message translates to:
  /// **'فضي'**
  String get colSilver;

  /// No description provided for @catCap.
  ///
  /// In ar, this message translates to:
  /// **'قبعة'**
  String get catCap;

  /// No description provided for @catBeanie.
  ///
  /// In ar, this message translates to:
  /// **'قبعة صوفية'**
  String get catBeanie;

  /// No description provided for @catTurban.
  ///
  /// In ar, this message translates to:
  /// **'توربان'**
  String get catTurban;

  /// No description provided for @catNeckScarf.
  ///
  /// In ar, this message translates to:
  /// **'وشاح'**
  String get catNeckScarf;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ar':
      {
        switch (locale.countryCode) {
          case 'EG':
            return AppLocalizationsArEg();
          case 'SA':
            return AppLocalizationsArSa();
        }
        break;
      }
  }

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
