// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nyankole (`nyn`).
class AppLocalizationsNyn extends AppLocalizations {
  AppLocalizationsNyn([String locale = 'nyn']) : super(locale);

  @override
  String get language => 'Runyankole - UGX';

  @override
  String get titleSignIn =>
      'Kakasire okwinjira omuzannyo ogwitwa FinSim Kikuyambe okuza omu muzano ogurikwetwa FinSim';

  @override
  String get welcomeText =>
      'Muzannyi wangye, omuzannyo guno guri gutekateeka emiringyezo era guri gwa kwigisha. Okuzannya omuzannyo guno tekijja kuhindura mburamu yawe na Bank yawe. Nkakasire kuterekera ebikukwatako munsi';

  @override
  String get hintFirstName => 'Erinja rya mbere';

  @override
  String get hintLastName => 'Erinja ryokubiri';

  @override
  String get continueButton => 'continue';

  @override
  String get overview => 'Ahamuramutwe';

  @override
  String get personal => 'Ebyange';

  @override
  String get assets => 'income from assets';

  @override
  String get pig => 'pig';

  @override
  String get chicken => 'chicken';

  @override
  String get goat => 'Embuzi';

  @override
  String get error => 'error';

  @override
  String get cashAlert => 'not enough cash!';

  @override
  String get confirm => 'okay';

  @override
  String get howToPlay => 'Enkora y\'okuzannya';

  @override
  String get instructionText1 =>
      '1. To start the game click the “NEXT” button in the top right corner.';

  @override
  String get instructionText2 =>
      '2. You can buy an animal with cash, take a loan or decide not to buy the asset.';

  @override
  String get instructionText3 =>
      '3. Each round animals vary in price, income and life expectancy.';

  @override
  String get instructionText4 =>
      '4. You might find the calculations underneath the animal card helpful.';

  @override
  String get instructionText5 =>
      '5. Orina okuhikiza omubarwa gw\'eshaaho ogukoresebwa kugira ngo oshobore okukomeho omutandara ogudako';

  @override
  String get instructionText6 =>
      '6. Oshobora okusanga enkora z\'okuzannya omuzannyo guno bwoba orikuteekateeka';

  @override
  String get warning => 'Okutebarura';

  @override
  String get investmentOptions => 'Investment Options';

  @override
  String get tip => 'Ekipimo';

  @override
  String get dontBuy => 'don\'t buy';

  @override
  String get payCash => 'Gura';

  @override
  String get borrow => 'borrow';

  @override
  String get lostGame =>
      'Obushabwe, eshaaho bwaguze. Oshobora kuddamu omutandara guno oba okutandika omuzannyo omupya.';

  @override
  String get restartLevel => 'Ddamu omutandara guno';

  @override
  String get restartGame => 'Tandika omuzannyo omupya';

  @override
  String get settings => 'Ebiteekateeko';

  @override
  String get clearCache => 'clear cache';

  @override
  String get nextLevel => 'Omutandara ogudako';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName => 'please enter first and last name.';

  @override
  String get congratulations => 'congratulations';

  @override
  String get reachedNextLevel => 'Oshitsurize omutandara ogudako';

  @override
  String get next => 'Ekindako';

  @override
  String get cash => 'cash';

  @override
  String get expenses => 'expenses';

  @override
  String get gameFinished =>
      'congratulations you finished the game successfully!';

  @override
  String get restart => 'Tandika oburo';

  @override
  String get notMe => 'Oyo si nye';

  @override
  String get signInDifferentPerson => 'Hindura eshaaho orina';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Emwemerezo',
      one: 'Omwemerezo',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Obwire: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Emingyeezo: $cashAmount / omwaka';
  }

  @override
  String get income => 'Emingyeezo';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'life expectancy: $yearsNum years';
  }

  @override
  String lifeRisk(String number) {
    return 'risk: 1 out of $number will not survive';
  }

  @override
  String get cashGoal => 'cash goal';

  @override
  String assetDied(String asset) {
    return '$asset has died!';
  }

  @override
  String get assetsDied => 'animals have died!';

  @override
  String currentCash(String cashAmount) {
    return 'your current cash: $cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'borrow at $interestRate% simple interest over 2 periods';
  }

  @override
  String interestCash(String interestRate) {
    return 'Omugabo bwogura n\'okukozesa eshaaho orina guri $interestRate% / omwaka';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'level $level / $levelTotal';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'cash goal: reach $cashAmount ';
  }

  @override
  String get languagesTitle => 'Enimi';

  @override
  String sameUser(String firstName) {
    return 'Niba oye $firstName, tandika omuzannyo';
  }

  @override
  String startAtLevel(String level) {
    return 'Tandika ku mutandara $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Webare kugaruka, $firstName $lastName';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Nyoreka oronde omurimi:';

  @override
  String get hintUID => 'namba y\'omukozesa. eg. UGRT999';

  @override
  String get confirmNameTitle => 'Kakasa erinja ryawe';

  @override
  String confirmName(String firstName, String lastName) {
    return 'Oye $firstName $lastName?';
  }

  @override
  String get noButton => 'Eipesha rwa Ngaaha';

  @override
  String get yesButton => 'Eipesha rya Eego';

  @override
  String get codeNotFound => 'Koodi tiyanzurwe';

  @override
  String get noCodeButton => 'Tihariho eipesha rya koodi';

  @override
  String get signInName =>
      'Handikamu eizina ryawe. Nyoreka oyingire erinja ryawe rya mbere neryokubiri:';

  @override
  String get backButton => 'Eipesha ry’Okugaruka enyiima';
}
