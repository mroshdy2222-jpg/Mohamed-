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
  String get navToday => 'اليوم';

  @override
  String get navWardrobe => 'الخزانة';

  @override
  String get navVote => 'التصويت';

  @override
  String get navAccount => 'حسابي';

  @override
  String get todayTitle => 'إطلالة اليوم';

  @override
  String weatherLine(int temp, String city) {
    return '$temp° $city';
  }

  @override
  String get wearIt => 'سأختاره';

  @override
  String get dressMeAgain => 'اختيار آخر';

  @override
  String get askFriends => 'اسأل أصدقاءك';

  @override
  String get lockHint => 'اضغط على قطعة لتثبيتها';

  @override
  String get lockedLabel => 'مثبّتة';

  @override
  String get noOutfit => 'لم نجد إطلالة مناسبة';

  @override
  String get noOutfitHint => 'جرّب أسلوبًا آخر، أو أضف قطعًا إلى الخزانة، أو تحقّق مما في الغسيل.';

  @override
  String get withWhomTitle => 'مع من كنت؟';

  @override
  String get withWhomHint => 'اختياري، مثل: عائلة أمي';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get wornSaved => 'سُجّلت في سجل الملابس';

  @override
  String wornBefore(String date) {
    return 'ارتديت قطعة من هذه الإطلالة أمام الأشخاص أنفسهم يوم $date';
  }

  @override
  String get reasonNeutrals => 'ألوان محايدة بالكامل، اختيار آمن وأنيق.';

  @override
  String get reasonAccent => 'لون واحد بارز على ألوان هادئة، فتبدو الإطلالة متوازنة.';

  @override
  String get reasonMonochrome => 'درجات من اللون نفسه، مظهر متناسق ومرتب.';

  @override
  String get reasonAnalogous => 'لونان متجاوران في دائرة الألوان، يتناغمان بهدوء.';

  @override
  String get reasonComplementary => 'لونان متقابلان، فالإطلالة لافتة ومتوازنة.';

  @override
  String get reasonClash => 'ألوان جريئة معًا، إن أردت لفت الأنظار.';

  @override
  String get noteCold => 'أضفنا طبقة لأن الجو بارد.';

  @override
  String get noteHot => 'قطع خفيفة لأن الجو حار.';

  @override
  String get wardrobeTitle => 'الخزانة';

  @override
  String wardrobeCount(int count) {
    return '$count قطعة';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get statusLaundry => 'في الغسيل';

  @override
  String get statusLent => 'مُعارة';

  @override
  String get statusAvailable => 'متاحة';

  @override
  String get emptyWardrobe => 'الخزانة فارغة. ابدأ بالأساسيات.';

  @override
  String get addBasics => 'أضف الأساسيات';

  @override
  String get basicsTitle => 'هل تملك هذه القطع؟';

  @override
  String get basicsHint => 'اضغط على ما تملكه، ويمكنك تصويره لاحقًا.';

  @override
  String get basicsDone => 'لنرَ إطلالة اليوم';

  @override
  String basicsSelected(int count) {
    return '$count قطعة';
  }

  @override
  String get genderQuestion => 'لمن هذا التطبيق؟';

  @override
  String get genderFemale => 'نساء';

  @override
  String get genderMale => 'رجال';

  @override
  String get hijabQuestion => 'هل ترتدين الحجاب؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get voteTitle => 'هذا أم ذاك؟';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get occasionLabel => 'المناسبة';

  @override
  String get styleLabel => 'الأسلوب';

  @override
  String get catTop => 'ملابس علوية';

  @override
  String get catBottom => 'ملابس سفلية';

  @override
  String get catOnePiece => 'قطعة واحدة';

  @override
  String get catOuterwear => 'سترات';

  @override
  String get catShoes => 'أحذية';

  @override
  String get catBag => 'حقائب';

  @override
  String get catHeadscarf => 'أوشحة';

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
  String get occWork => 'عمل';

  @override
  String get occOuting => 'نزهة';

  @override
  String get occDate => 'موعد';

  @override
  String get occInterview => 'مقابلة عمل';

  @override
  String get occWedding => 'حفل زفاف';

  @override
  String get occEngagement => 'خطوبة';

  @override
  String get occEid => 'عيد';

  @override
  String get occHome => 'المنزل';

  @override
  String get occGym => 'نادٍ رياضي';

  @override
  String get occParty => 'حفلة';

  @override
  String get colWhite => 'أبيض';

  @override
  String get colCream => 'عاجي';

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
  String get colPink => 'وردي';

  @override
  String get colBlush => 'وردي فاتح';

  @override
  String get colOrange => 'برتقالي';

  @override
  String get colMustard => 'خردلي';

  @override
  String get colYellow => 'أصفر';

  @override
  String get colGreen => 'أخضر';

  @override
  String get colEmerald => 'زمردي';

  @override
  String get colTeal => 'أزرق مخضر';

  @override
  String get colSky => 'سماوي';

  @override
  String get colBlue => 'أزرق';

  @override
  String get colLavender => 'لافندر';

  @override
  String get colPurple => 'بنفسجي';

  @override
  String get cityCairo => 'القاهرة';

  @override
  String get addItem => 'أضف قطعة';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get fromGallery => 'من المعرض';

  @override
  String get photoOptional => 'الصورة اختيارية. بدونها تظهر القطعة بشكلها ولونها.';

  @override
  String get categoryLabel => 'النوع';

  @override
  String get colorLabel => 'اللون';

  @override
  String get stylesLabel => 'ما الأساليب التي تناسبها؟';

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
  String get patternChecked => 'مربعات';

  @override
  String get patternPrinted => 'مطبوع';

  @override
  String get saveItem => 'أضفها إلى الخزانة';

  @override
  String get itemAdded => 'أُضيفت القطعة';

  @override
  String get deleteItem => 'احذفها من الخزانة';

  @override
  String get cityAlexandria => 'الإسكندرية';

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

  @override
  String get arabicEgyptian => 'مصري';

  @override
  String get arabicGulf => 'خليجي';

  @override
  String get arabicStandard => 'فصحى';

  @override
  String get pollIntro => 'أنشئ صورة فيها إطلالتان وأرسلها لأصدقائك على واتساب، ليردّوا بالرقم 1 أو 2.';

  @override
  String get newPoll => 'تصويت جديد';

  @override
  String get sendPoll => 'أرسلها لأصدقائك';

  @override
  String get swapOption => 'غيّر الإطلالة 2';

  @override
  String get replyWithNumber => 'ردّ بالرقم 1 أو 2';

  @override
  String shareText(String occasion) {
    return 'أيهما أفضل؟ المناسبة: $occasion. ردّ بالرقم 1 أو 2.';
  }

  @override
  String get whoWon => 'أيهما فاز؟';

  @override
  String optionLabel(int n) {
    return 'إطلالة $n';
  }

  @override
  String get winnerLabel => 'الفائز';

  @override
  String get noPolls => 'لم تنشئ أي تصويت بعد.';

  @override
  String get pollNeedsMore => 'تحتاج إلى قطع أكثر لتكوين إطلالتين مختلفتين.';

  @override
  String get pollsHistory => 'تصويتاتك';

  @override
  String get missingTitle => 'ما الذي ينقصك؟';

  @override
  String missingGain(String item, int count, String style) {
    return 'لو كانت لديك $item لكوّنت $count إطلالة إضافية بأسلوب $style.';
  }

  @override
  String get iHaveIt => 'أملكها';

  @override
  String get missingNone => 'خزانتك مكتملة في هذا الأسلوب.';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

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
  String get wearIt => 'هختاره';

  @override
  String get dressMeAgain => 'اختيار تاني';

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
  String get languageLabel => 'اللغة';

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

  @override
  String get arabicEgyptian => 'مصري';

  @override
  String get arabicGulf => 'خليجي';

  @override
  String get arabicStandard => 'فصحى';

  @override
  String get pollIntro => 'اعمل صورة فيها طقمين وابعتها لصحابك على واتساب، وهم يردوا برقم 1 أو 2.';

  @override
  String get newPoll => 'تصويت جديد';

  @override
  String get sendPoll => 'ابعتها لصحابك';

  @override
  String get swapOption => 'غيّر الطقم 2';

  @override
  String get replyWithNumber => 'رد برقم 1 أو 2';

  @override
  String shareText(String occasion) {
    return 'ده ولا ده؟ المناسبة: $occasion. رد برقم 1 أو 2.';
  }

  @override
  String get whoWon => 'مين كسب؟';

  @override
  String optionLabel(int n) {
    return 'طقم $n';
  }

  @override
  String get winnerLabel => 'الكسبان';

  @override
  String get noPolls => 'لسه ماعملتش تصويت.';

  @override
  String get pollNeedsMore => 'محتاج قطع أكتر عشان نعمل طقمين مختلفين.';

  @override
  String get pollsHistory => 'تصويتاتك';

  @override
  String get missingTitle => 'ناقصك إيه؟';

  @override
  String missingGain(String item, int count, String style) {
    return 'لو عندك $item هتعمل $count طقم زيادة في ستايل $style.';
  }

  @override
  String get iHaveIt => 'عندي دي';

  @override
  String get missingNone => 'دولابك مكتمل في الستايل ده.';
}

/// The translations for Arabic, as used in Saudi Arabia (`ar_SA`).
class AppLocalizationsArSa extends AppLocalizationsAr {
  AppLocalizationsArSa() : super('ar_SA');

  @override
  String get appTitle => 'طالا';

  @override
  String get navToday => 'اليوم';

  @override
  String get navWardrobe => 'الكبت';

  @override
  String get navVote => 'التصويت';

  @override
  String get navAccount => 'حسابي';

  @override
  String get todayTitle => 'لبسة اليوم';

  @override
  String weatherLine(int temp, String city) {
    return '$temp° $city';
  }

  @override
  String get wearIt => 'بختاره';

  @override
  String get dressMeAgain => 'اختيار ثاني';

  @override
  String get askFriends => 'خذ رأي ربعك';

  @override
  String get lockHint => 'اضغط على قطعة عشان تثبّتها';

  @override
  String get lockedLabel => 'مثبّتة';

  @override
  String get noOutfit => 'ما لقينا لبسة مناسبة';

  @override
  String get noOutfitHint => 'جرّب ستايل ثاني، أو ضيف قطع للكبت، أو شوف إذا فيه شي بالغسيل.';

  @override
  String get withWhomTitle => 'كنت مع منو؟';

  @override
  String get withWhomHint => 'اختياري، مثل: أهل أمي';

  @override
  String get save => 'سجّل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get wornSaved => 'انحفظت في سجل اللبس';

  @override
  String wornBefore(String date) {
    return 'لبست قطعة من هاللبسة قدام نفس الناس يوم $date';
  }

  @override
  String get reasonNeutrals => 'ألوان هادية كلها، اختيار مضمون وأنيق.';

  @override
  String get reasonAccent => 'لون واحد بارز على ألوان هادية، فاللبسة متوازنة.';

  @override
  String get reasonMonochrome => 'درجات من نفس اللون، شكل مرتب ومتناسق.';

  @override
  String get reasonAnalogous => 'لونين قريبين من بعض، يمشون مع بعض بهدوء.';

  @override
  String get reasonComplementary => 'لونين عكس بعض، فاللبسة ملفتة ومتوازنة.';

  @override
  String get reasonClash => 'ألوان جريئة مع بعض، إذا تبي تلفت النظر.';

  @override
  String get noteCold => 'ضفنا طبقة لأن الجو بارد.';

  @override
  String get noteHot => 'قطع خفيفة لأن الجو حار.';

  @override
  String get wardrobeTitle => 'الكبت';

  @override
  String wardrobeCount(int count) {
    return '$count قطعة';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get statusLaundry => 'بالغسيل';

  @override
  String get statusLent => 'سلّفتها';

  @override
  String get statusAvailable => 'موجودة';

  @override
  String get emptyWardrobe => 'الكبت فاضي. ابدأ بالأساسيات.';

  @override
  String get addBasics => 'ضيف الأساسيات';

  @override
  String get basicsTitle => 'عندك هالأغراض؟';

  @override
  String get basicsHint => 'اضغط على اللي عندك، وتقدر تصوّرها بعدين.';

  @override
  String get basicsDone => 'يلا نشوف لبسة اليوم';

  @override
  String basicsSelected(int count) {
    return '$count قطعة';
  }

  @override
  String get genderQuestion => 'التطبيق لك ولا لج؟';

  @override
  String get genderFemale => 'حريم';

  @override
  String get genderMale => 'رجال';

  @override
  String get hijabQuestion => 'تلبسين شيلة؟';

  @override
  String get yes => 'إي';

  @override
  String get no => 'لا';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get voteTitle => 'هذا ولا هذا؟';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get occasionLabel => 'المناسبة';

  @override
  String get styleLabel => 'الستايل';

  @override
  String get catTop => 'لبس فوق';

  @override
  String get catBottom => 'لبس تحت';

  @override
  String get catOnePiece => 'قطعة وحدة';

  @override
  String get catOuterwear => 'جاكيت';

  @override
  String get catShoes => 'أحذية';

  @override
  String get catBag => 'شنط';

  @override
  String get catHeadscarf => 'شيلات';

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
  String get occWork => 'دوام';

  @override
  String get occOuting => 'طلعة';

  @override
  String get occDate => 'موعد';

  @override
  String get occInterview => 'مقابلة وظيفية';

  @override
  String get occWedding => 'عرس';

  @override
  String get occEngagement => 'خطوبة';

  @override
  String get occEid => 'عيد';

  @override
  String get occHome => 'البيت';

  @override
  String get occGym => 'نادي';

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
  String get colPink => 'وردي';

  @override
  String get colBlush => 'وردي فاتح';

  @override
  String get colOrange => 'برتقالي';

  @override
  String get colMustard => 'خردلي';

  @override
  String get colYellow => 'أصفر';

  @override
  String get colGreen => 'أخضر';

  @override
  String get colEmerald => 'زمردي';

  @override
  String get colTeal => 'تيل';

  @override
  String get colSky => 'سماوي';

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
  String get photoOptional => 'الصورة اختيارية. بدونها تطلع القطعة بشكلها ولونها.';

  @override
  String get categoryLabel => 'النوع';

  @override
  String get colorLabel => 'اللون';

  @override
  String get stylesLabel => 'تمشي مع أي ستايل؟';

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
  String get patternChecked => 'كاروهات';

  @override
  String get patternPrinted => 'مطبوع';

  @override
  String get saveItem => 'ضيفها للكبت';

  @override
  String get itemAdded => 'انضافت القطعة';

  @override
  String get deleteItem => 'امسحها من الكبت';

  @override
  String get cityAlexandria => 'الإسكندرية';

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

  @override
  String get arabicEgyptian => 'مصري';

  @override
  String get arabicGulf => 'خليجي';

  @override
  String get arabicStandard => 'فصحى';

  @override
  String get pollIntro => 'سوّ صورة فيها لبستين وأرسلها لربعك على واتساب، وهم يردون برقم 1 أو 2.';

  @override
  String get newPoll => 'تصويت جديد';

  @override
  String get sendPoll => 'أرسلها لربعك';

  @override
  String get swapOption => 'غيّر اللبسة 2';

  @override
  String get replyWithNumber => 'رد برقم 1 أو 2';

  @override
  String shareText(String occasion) {
    return 'هذا ولا هذا؟ المناسبة: $occasion. رد برقم 1 أو 2.';
  }

  @override
  String get whoWon => 'منو فاز؟';

  @override
  String optionLabel(int n) {
    return 'لبسة $n';
  }

  @override
  String get winnerLabel => 'الفايز';

  @override
  String get noPolls => 'ما سويت تصويت للحين.';

  @override
  String get pollNeedsMore => 'تحتاج قطع أكثر عشان نسوي لبستين مختلفتين.';

  @override
  String get pollsHistory => 'تصويتاتك';

  @override
  String get missingTitle => 'وش ناقصك؟';

  @override
  String missingGain(String item, int count, String style) {
    return 'لو عندك $item بتسوي $count لبسة زيادة في ستايل $style.';
  }

  @override
  String get iHaveIt => 'عندي هذي';

  @override
  String get missingNone => 'كبتك مكتمل في هالستايل.';
}
