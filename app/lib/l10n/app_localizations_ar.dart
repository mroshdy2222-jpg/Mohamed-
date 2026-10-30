// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'طالا';

  @override
  String get navToday => 'النهارده';

  @override
  String get navWardrobe => 'الدولاب';

  @override
  String get navVote => 'التصويت';

  @override
  String get navAccount => 'حسابي';

  @override
  String get todayTitle => 'طقم النهارده';

  @override
  String weatherLine(int temp, String city) {
    return '$temp° $city';
  }

  @override
  String get wearIt => 'هلبسه';

  @override
  String get dressMeAgain => 'لبّسني تاني';

  @override
  String get askFriends => 'خد رأي صحابك';

  @override
  String get lockHint => 'دوس على قطعة عشان تقفلها';

  @override
  String get lockedLabel => 'مقفولة';

  @override
  String get noOutfit => 'مش لاقيين طقم مناسب';

  @override
  String get noOutfitHint => 'جرّب ستايل تاني، أو ضيف قطع للدولاب، أو شوف لو حاجة في الغسيل.';

  @override
  String get withWhomTitle => 'كنت مع مين؟';

  @override
  String get withWhomHint => 'اختياري، زي: عيلة ماما';

  @override
  String get save => 'سجّل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get wornSaved => 'اتسجل في سجل اللبس';

  @override
  String wornBefore(String date) {
    return 'لبست قطعة من الطقم ده قدام نفس الناس يوم $date';
  }

  @override
  String get reasonNeutrals => 'ألوان محايدة كلها، اختيار آمن ونضيف.';

  @override
  String get reasonAccent => 'لون واحد بارز على ألوان هادية، فالطقم متوازن.';

  @override
  String get reasonMonochrome => 'درجات من نفس اللون، شكل متناسق ومرتب.';

  @override
  String get reasonAnalogous => 'لونين جيران على دايرة الألوان، فبيمشوا مع بعض بهدوء.';

  @override
  String get reasonComplementary => 'لونين عكس بعض، فالطقم لافت ومتوازن.';

  @override
  String get reasonClash => 'ألوان جريئة مع بعض، لو حابب تلفت النظر.';

  @override
  String get noteCold => 'ضفنا طبقة عشان الجو برد.';

  @override
  String get noteHot => 'قطع خفيفة عشان الجو حر.';

  @override
  String get wardrobeTitle => 'الدولاب';

  @override
  String wardrobeCount(int count) {
    return '$count قطعة';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get statusLaundry => 'في الغسيل';

  @override
  String get statusLent => 'مسلّفة';

  @override
  String get statusAvailable => 'موجودة';

  @override
  String get emptyWardrobe => 'الدولاب فاضي. ابدأ بالأساسيات.';

  @override
  String get addBasics => 'ضيف الأساسيات';

  @override
  String get basicsTitle => 'عندك الحاجات دي؟';

  @override
  String get basicsHint => 'دوس على اللي عندك، وتقدر تصوّرها بعدين.';

  @override
  String get basicsDone => 'يلا نشوف طقم النهارده';

  @override
  String basicsSelected(int count) {
    return '$count قطعة';
  }

  @override
  String get genderQuestion => 'التطبيق ليك ولا ليكي؟';

  @override
  String get genderFemale => 'ستات';

  @override
  String get genderMale => 'رجالة';

  @override
  String get hijabQuestion => 'بتلبسي حجاب؟';

  @override
  String get yes => 'أيوه';

  @override
  String get no => 'لأ';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get voteTitle => 'ده ولا ده؟';

  @override
  String get voteSoon => 'التصويت بلينك واتساب جاي في التحديث الجاي. لحد ما ييجي، رأي طالا بيظهر مع كل طقم.';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get arabic => 'العربي';

  @override
  String get english => 'English';

  @override
  String get occasionLabel => 'المناسبة';

  @override
  String get styleLabel => 'الستايل';

  @override
  String get catTop => 'لبس علوي';

  @override
  String get catBottom => 'لبس سفلي';

  @override
  String get catOnePiece => 'قطعة واحدة';

  @override
  String get catOuterwear => 'جاكت';

  @override
  String get catShoes => 'جزم';

  @override
  String get catBag => 'شنط';

  @override
  String get catHeadscarf => 'طرح';

  @override
  String get catShemagh => 'شماغ';

  @override
  String get catAccessory => 'إكسسوارات';

  @override
  String get styleLounge => 'بيتي';

  @override
  String get styleSport => 'رياضي';

  @override
  String get styleCasual => 'كاجوال';

  @override
  String get styleDrip => 'دريب';

  @override
  String get styleSmartCasual => 'سمارت كاجوال';

  @override
  String get styleFormal => 'فورمال';

  @override
  String get styleDressy => 'دريسي';

  @override
  String get styleTraditional => 'تراثي';

  @override
  String get occUniversity => 'جامعة';

  @override
  String get occWork => 'شغل';

  @override
  String get occOuting => 'خروجة';

  @override
  String get occDate => 'موعد';

  @override
  String get occInterview => 'مقابلة شغل';

  @override
  String get occWedding => 'فرح';

  @override
  String get occEngagement => 'خطوبة';

  @override
  String get occEid => 'عيد';

  @override
  String get occHome => 'البيت';

  @override
  String get occGym => 'جيم';

  @override
  String get occParty => 'حفلة';

  @override
  String get colWhite => 'أبيض';

  @override
  String get colCream => 'أوف وايت';

  @override
  String get colBlack => 'أسود';

  @override
  String get colGrey => 'رمادي';

  @override
  String get colNavy => 'كحلي';

  @override
  String get colDenim => 'جينز';

  @override
  String get colBeige => 'بيج';

  @override
  String get colCamel => 'كاميل';

  @override
  String get colBrown => 'بني';

  @override
  String get colOlive => 'زيتوني';

  @override
  String get colKhaki => 'كاكي';

  @override
  String get colRed => 'أحمر';

  @override
  String get colBurgundy => 'عنابي';

  @override
  String get colPink => 'بمبي';

  @override
  String get colBlush => 'روز';

  @override
  String get colOrange => 'برتقاني';

  @override
  String get colMustard => 'مستردة';

  @override
  String get colYellow => 'أصفر';

  @override
  String get colGreen => 'أخضر';

  @override
  String get colEmerald => 'زمردي';

  @override
  String get colTeal => 'تيل';

  @override
  String get colSky => 'لبني';

  @override
  String get colBlue => 'أزرق';

  @override
  String get colLavender => 'لافندر';

  @override
  String get colPurple => 'بنفسجي';

  @override
  String get cityCairo => 'القاهرة';

  @override
  String get addItem => 'ضيف قطعة';

  @override
  String get takePhoto => 'صوّر';

  @override
  String get fromGallery => 'من المعرض';

  @override
  String get photoOptional => 'الصورة اختيارية. من غيرها بيظهر شكل القطعة بلونها.';

  @override
  String get categoryLabel => 'النوع';

  @override
  String get colorLabel => 'اللون';

  @override
  String get stylesLabel => 'بتنفع في أنهي ستايل؟';

  @override
  String get seasonLabel => 'الموسم';

  @override
  String get seasonSummer => 'صيفي';

  @override
  String get seasonWinter => 'شتوي';

  @override
  String get seasonAll => 'كل المواسم';

  @override
  String get patternLabel => 'النقشة';

  @override
  String get patternSolid => 'سادة';

  @override
  String get patternStriped => 'مقلّم';

  @override
  String get patternChecked => 'كاروه';

  @override
  String get patternPrinted => 'مطبوع';

  @override
  String get saveItem => 'ضيفها للدولاب';

  @override
  String get itemAdded => 'القطعة اتضافت';

  @override
  String get deleteItem => 'امسحها من الدولاب';

  @override
  String get cityAlexandria => 'إسكندرية';

  @override
  String get cityRiyadh => 'الرياض';

  @override
  String get cityJeddah => 'جدة';

  @override
  String get cityDubai => 'دبي';

  @override
  String get cityAbuDhabi => 'أبوظبي';

  @override
  String get cityKuwait => 'الكويت';

  @override
  String get cityDoha => 'الدوحة';
}
