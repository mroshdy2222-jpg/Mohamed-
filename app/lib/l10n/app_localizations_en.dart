// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Talla';

  @override
  String get navToday => 'Today';

  @override
  String get navWardrobe => 'Wardrobe';

  @override
  String get navVote => 'Vote';

  @override
  String get navAccount => 'Account';

  @override
  String get todayTitle => 'Today\'s outfit';

  @override
  String weatherLine(int temp, String city) {
    return '$temp° $city';
  }

  @override
  String get wearIt => 'Choose this';

  @override
  String get dressMeAgain => 'Another option';

  @override
  String get askFriends => 'Ask friends';

  @override
  String get lockHint => 'Tap a piece to lock it';

  @override
  String get lockedLabel => 'Locked';

  @override
  String get noOutfit => 'No outfit fits yet';

  @override
  String get noOutfitHint => 'Try another style, add pieces, or check what\'s in the laundry.';

  @override
  String get withWhomTitle => 'Who were you with?';

  @override
  String get withWhomHint => 'Optional, e.g. Mum\'s family';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get wornSaved => 'Saved to your wear log';

  @override
  String wornBefore(String date) {
    return 'You wore a piece of this outfit with the same people on $date';
  }

  @override
  String get reasonNeutrals => 'All neutrals: safe and clean.';

  @override
  String get reasonAccent => 'One accent on calm neutrals keeps it balanced.';

  @override
  String get reasonMonochrome => 'Shades of one colour look polished.';

  @override
  String get reasonAnalogous => 'Two neighbouring colours blend calmly.';

  @override
  String get reasonComplementary => 'Opposite colours make a bold but balanced look.';

  @override
  String get reasonClash => 'Bold mix, if you want to stand out.';

  @override
  String get noteCold => 'We added a layer because it\'s cold.';

  @override
  String get noteHot => 'Light pieces for the heat.';

  @override
  String get wardrobeTitle => 'Wardrobe';

  @override
  String wardrobeCount(int count) {
    return '$count pieces';
  }

  @override
  String get filterAll => 'All';

  @override
  String get statusLaundry => 'In the laundry';

  @override
  String get statusLent => 'Lent';

  @override
  String get statusAvailable => 'Available';

  @override
  String get emptyWardrobe => 'Your wardrobe is empty. Start with the basics.';

  @override
  String get addBasics => 'Add basics';

  @override
  String get basicsTitle => 'Do you have these?';

  @override
  String get basicsHint => 'Tap what you own. You can photograph them later.';

  @override
  String get basicsDone => 'Show today\'s outfit';

  @override
  String basicsSelected(int count) {
    return '$count pieces';
  }

  @override
  String get genderQuestion => 'Who is this for?';

  @override
  String get genderFemale => 'Women';

  @override
  String get genderMale => 'Men';

  @override
  String get hijabQuestion => 'Do you wear a hijab?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get cityLabel => 'City';

  @override
  String get voteTitle => 'This or that?';

  @override
  String get languageLabel => 'Language';

  @override
  String get english => 'English';

  @override
  String get occasionLabel => 'Occasion';

  @override
  String get styleLabel => 'Style';

  @override
  String get catTop => 'Top';

  @override
  String get catBottom => 'Bottom';

  @override
  String get catOnePiece => 'One-piece';

  @override
  String get catOuterwear => 'Outerwear';

  @override
  String get catShoes => 'Shoes';

  @override
  String get catBag => 'Bags';

  @override
  String get catHeadscarf => 'Headscarves';

  @override
  String get catShemagh => 'Shemagh';

  @override
  String get catAccessory => 'Accessories';

  @override
  String get styleLounge => 'Lounge';

  @override
  String get styleSport => 'Sport';

  @override
  String get styleCasual => 'Casual';

  @override
  String get styleDrip => 'Drip';

  @override
  String get styleSmartCasual => 'Smart casual';

  @override
  String get styleFormal => 'Formal';

  @override
  String get styleDressy => 'Dressy';

  @override
  String get styleTraditional => 'Traditional';

  @override
  String get occUniversity => 'University';

  @override
  String get occWork => 'Work';

  @override
  String get occOuting => 'Outing';

  @override
  String get occDate => 'Date';

  @override
  String get occInterview => 'Interview';

  @override
  String get occWedding => 'Wedding';

  @override
  String get occEngagement => 'Engagement';

  @override
  String get occEid => 'Eid';

  @override
  String get occHome => 'Home';

  @override
  String get occGym => 'Gym';

  @override
  String get occParty => 'Party';

  @override
  String get colWhite => 'White';

  @override
  String get colCream => 'Cream';

  @override
  String get colBlack => 'Black';

  @override
  String get colGrey => 'Grey';

  @override
  String get colNavy => 'Navy';

  @override
  String get colDenim => 'Denim';

  @override
  String get colBeige => 'Beige';

  @override
  String get colCamel => 'Camel';

  @override
  String get colBrown => 'Brown';

  @override
  String get colOlive => 'Olive';

  @override
  String get colKhaki => 'Khaki';

  @override
  String get colRed => 'Red';

  @override
  String get colBurgundy => 'Burgundy';

  @override
  String get colPink => 'Pink';

  @override
  String get colBlush => 'Blush';

  @override
  String get colOrange => 'Orange';

  @override
  String get colMustard => 'Mustard';

  @override
  String get colYellow => 'Yellow';

  @override
  String get colGreen => 'Green';

  @override
  String get colEmerald => 'Emerald';

  @override
  String get colTeal => 'Teal';

  @override
  String get colSky => 'Sky blue';

  @override
  String get colBlue => 'Blue';

  @override
  String get colLavender => 'Lavender';

  @override
  String get colPurple => 'Purple';

  @override
  String get cityCairo => 'Cairo';

  @override
  String get addItem => 'Add a piece';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get photoOptional => 'The photo is optional. Shoot the piece on its own, on a bed or a hanger.';

  @override
  String get categoryLabel => 'Type';

  @override
  String get colorLabel => 'Colour';

  @override
  String get stylesLabel => 'Which styles does it suit?';

  @override
  String get seasonLabel => 'Season';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get seasonAll => 'All seasons';

  @override
  String get patternLabel => 'Pattern';

  @override
  String get patternSolid => 'Solid';

  @override
  String get patternStriped => 'Striped';

  @override
  String get patternChecked => 'Checked';

  @override
  String get patternPrinted => 'Printed';

  @override
  String get saveItem => 'Add to wardrobe';

  @override
  String get itemAdded => 'Piece added';

  @override
  String get deleteItem => 'Remove from wardrobe';

  @override
  String get cityAlexandria => 'Alexandria';

  @override
  String get cityRiyadh => 'Riyadh';

  @override
  String get cityJeddah => 'Jeddah';

  @override
  String get cityDubai => 'Dubai';

  @override
  String get cityAbuDhabi => 'Abu Dhabi';

  @override
  String get cityKuwait => 'Kuwait';

  @override
  String get cityDoha => 'Doha';

  @override
  String get arabicEgyptian => 'مصري';

  @override
  String get arabicGulf => 'خليجي';

  @override
  String get arabicStandard => 'فصحى';

  @override
  String get pollIntro => 'Make one image with two outfits and send it to friends on WhatsApp. They reply with 1 or 2.';

  @override
  String get newPoll => 'New poll';

  @override
  String get sendPoll => 'Send to friends';

  @override
  String get swapOption => 'Change outfit 2';

  @override
  String get replyWithNumber => 'Reply 1 or 2';

  @override
  String shareText(String occasion) {
    return 'This or that? Occasion: $occasion. Reply 1 or 2.';
  }

  @override
  String get whoWon => 'Which won?';

  @override
  String optionLabel(int n) {
    return 'Outfit $n';
  }

  @override
  String get winnerLabel => 'Winner';

  @override
  String get noPolls => 'No polls yet.';

  @override
  String get pollNeedsMore => 'Add more pieces to make two different outfits.';

  @override
  String get pollsHistory => 'Your polls';

  @override
  String get missingTitle => 'What\'s missing?';

  @override
  String missingGain(String item, int count, String style) {
    return 'With a $item you\'d have $count more $style outfits.';
  }

  @override
  String get iHaveIt => 'I have this';

  @override
  String get missingNone => 'Your wardrobe is complete for this style.';

  @override
  String get tagging => 'Talla is reading the piece…';

  @override
  String get tagged => 'Talla filled in the details. Check them before adding.';

  @override
  String get tagPerson => 'Photograph the piece on its own, not being worn.';

  @override
  String get tagFailed => 'Couldn\'t read it. Pick the details yourself.';
}
