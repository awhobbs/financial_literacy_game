// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Acoli (`ach`).
class AppLocalizationsAch extends AppLocalizations {
  AppLocalizationsAch([String locale = 'ach']) : super(locale);

  @override
  String get language => 'Acholi - UGX';

  @override
  String get titleSignIn => 'Dony i tuku game ma ki nyinge FinSim';

  @override
  String get welcomeText =>
      'Apwoyo, game man tye me konyo i ngec me cente. Pe iromo loko ngec me bank mamegi. Ket wiye wiye me ngec mamegi piny.';

  @override
  String get hintFirstName => 'Nyinge mada ma megi kacel';

  @override
  String get hintLastName => 'Nyinge mada ma megi aryo';

  @override
  String get continueButton => 'Mede';

  @override
  String get overview => 'Neno weng';

  @override
  String get personal => 'Mamegi';

  @override
  String get assets => 'lim ma tye';

  @override
  String get pig => 'pig';

  @override
  String get chicken => 'Gweno';

  @override
  String get goat => 'Dyel';

  @override
  String get error => 'Bal';

  @override
  String get cashAlert => 'cente mamegi pe tye kakare';

  @override
  String get confirm => 'moko';

  @override
  String get howToPlay => 'Kit ma ki tuku kwede';

  @override
  String get instructionText1 =>
      '1. Me cako kwede, dong i button ma ki coo ni “EKIDDAKO” i wiye i anyim';

  @override
  String get instructionText2 =>
      '2. Iromo kwero jami me iyie i centr mamegi, onyo den, onyo pe iromo mede';

  @override
  String get instructionText3 =>
      '3. I cawa ducu, jami mamegi romo bedo goro, cente mamegi romo bedo mang mang';

  @override
  String get instructionText4 =>
      '4. Namba ma tye i piny pi jami mito ni tye me konyo';

  @override
  String get instructionText5 =>
      '5. Imito ni cente mamegi tye kakare me romo mede i level mukene';

  @override
  String get instructionText6 =>
      '6. Iromo nong kit matye me kwede game man me iromo peko ni';

  @override
  String get warning => 'Koko';

  @override
  String get investmentOptions => 'Jami ma iromo timo';

  @override
  String get tip => 'wiye';

  @override
  String get dontBuy => 'Pe i wil';

  @override
  String get payCash => 'cul ma kom cente';

  @override
  String get borrow => 'den';

  @override
  String get lostGame =>
      'Bal, cente mamegi orem. Iromo dwoko level man onyo cako game mukene.';

  @override
  String get restartLevel => 'Dwoko level man';

  @override
  String get restartGame => 'Cak game mukene';

  @override
  String get settings => 'Tee';

  @override
  String get clearCache => 'ruc cak me memory';

  @override
  String get nextLevel => 'Level mekene';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName => 'Ket nyinge mada ma megi kacel ki ma aryo';

  @override
  String get congratulations => 'Wapwoyo matek';

  @override
  String get reachedNextLevel => 'I dong i level mukene';

  @override
  String get next => 'mukene';

  @override
  String get cash => 'cash';

  @override
  String get expenses => 'cente ma ityo kwede';

  @override
  String get gameFinished => 'tuku otum';

  @override
  String get restart => 'Cak doki';

  @override
  String get notMe => 'Man pe an';

  @override
  String get signInDifferentPerson => 'loko cente mamegi';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Loans',
      one: 'Loan',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'wele: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'cente ma icwalo: $cashAmount / mwaka';
  }

  @override
  String get income => 'cente ma icwalo';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'Tye kwede: mwaka $yearsNum';
  }

  @override
  String lifeRisk(String number) {
    return 'romo tye: 1 i $number bi tye kwede';
  }

  @override
  String get cashGoal => 'cente ma imito ni';

  @override
  String assetDied(String asset) {
    return '$asset lim otoo';
  }

  @override
  String get assetsDied => 'lim ma otoo';

  @override
  String currentCash(String cashAmount) {
    return 'cente mamegi: $cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'den i $interestRate% odoco';
  }

  @override
  String interestCash(String interestRate) {
    return 'magona ma iwii i cente mamegi tye $interestRate% / mwaka';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'Level $level / $levelTotal';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'cente ma imito ni: Tye $cashAmount';
  }

  @override
  String get languagesTitle => 'Leb';

  @override
  String sameUser(String firstName) {
    return 'Ka nyinye $firstName, cako game';
  }

  @override
  String startAtLevel(String level) {
    return 'Cako i level $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Apwoyo matek, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Yer lok ma imito:';

  @override
  String get hintUID => 'namba me user. cal, UGRT999';

  @override
  String get confirmNameTitle => 'mok nyinge mada ma megi';

  @override
  String confirmName(String firstName, String lastName) {
    return 'mok Nyinge $firstName $lastName?';
  }

  @override
  String get noButton => 'ku';

  @override
  String get yesButton => 'Eeyo';

  @override
  String get codeNotFound => 'Code pe tye';

  @override
  String get noCodeButton => 'Pe tye code';

  @override
  String get signInName => 'Ket nyinge mada ma megi kacel ki aryo:';

  @override
  String get backButton => 'Dok cen';
}
