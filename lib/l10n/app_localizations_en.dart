// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English - USD';

  @override
  String get titleSignIn => 'welcome to the FinSim Game';

  @override
  String get welcomeText =>
      'Dear participants,\nthis game is meant to mimic financial investments. It will only be used for the purpose of teaching. This game will not affect the relationship with your bank.\nPlease enter your code below:';

  @override
  String get hintFirstName => 'first name';

  @override
  String get hintLastName => 'last name';

  @override
  String get continueButton => 'continue';

  @override
  String get overview => 'overview';

  @override
  String get personal => 'personal';

  @override
  String get assets => 'income from assets';

  @override
  String get pig => 'pig';

  @override
  String get chicken => 'chicken';

  @override
  String get goat => 'goat';

  @override
  String get error => 'error';

  @override
  String get cashAlert => 'not enough cash!';

  @override
  String get confirm => 'okay';

  @override
  String get howToPlay => 'How to Play';

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
      '5. You have to reach a certain cash amount to make it to the next level.';

  @override
  String get instructionText6 =>
      '6. You can find these game instructions in the settings menu.';

  @override
  String get warning => 'warning';

  @override
  String get investmentOptions => 'Investment Options';

  @override
  String get tip => 'tip';

  @override
  String get dontBuy => 'don\'t buy';

  @override
  String get payCash => 'pay cash';

  @override
  String get borrow => 'borrow';

  @override
  String get lostGame =>
      'unfortunately you ran out of cash. You can either restart this level or start a new game.';

  @override
  String get restartLevel => 'restart level';

  @override
  String get restartGame => 'restart game';

  @override
  String get settings => 'settings';

  @override
  String get clearCache => 'clear cache';

  @override
  String get nextLevel => 'next level';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName => 'please enter first and last name.';

  @override
  String get congratulations => 'congratulations';

  @override
  String get reachedNextLevel => 'you have reached the next level!';

  @override
  String get next => 'next';

  @override
  String get cash => 'cash';

  @override
  String get expenses => 'expenses';

  @override
  String get gameFinished =>
      'congratulations you finished the game successfully!';

  @override
  String get restart => 'restart';

  @override
  String get notMe => 'that\'s not me';

  @override
  String get signInDifferentPerson =>
      'if that is not you, please sign in as a different person.';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'loans',
      one: 'loan',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'price: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'income: $cashAmount / year';
  }

  @override
  String get income => 'income';

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
    return '• Interest rate on cash is $interestRate% / year';
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
  String get languagesTitle => 'languages';

  @override
  String sameUser(String firstName) {
    return 'If you are $firstName, simply start the game.';
  }

  @override
  String startAtLevel(String level) {
    return 'start at level $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Welcome back, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Please select language:';

  @override
  String get hintUID => 'e.g. UGRT999';

  @override
  String get confirmNameTitle => 'Confirm your name';

  @override
  String confirmName(String firstName, String lastName) {
    return 'Are you $firstName $lastName?';
  }

  @override
  String get noButton => 'No';

  @override
  String get yesButton => 'Yes';

  @override
  String get codeNotFound => 'CODE NOT FOUND';

  @override
  String get noCodeButton => 'No code';

  @override
  String get signInName => 'Please sign in with your first and last name: \n';

  @override
  String get backButton => 'Back';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get language => 'English - USD';

  @override
  String get titleSignIn => 'welcome to the FinSim Game';

  @override
  String get welcomeText =>
      'Dear participants,\nthis game is meant to mimic financial investments. It will only be used for the purpose of teaching. This game will not affect the relationship with your bank.\nPlease enter your code below:';

  @override
  String get hintFirstName => 'first name';

  @override
  String get hintLastName => 'last name';

  @override
  String get continueButton => 'continue';

  @override
  String get overview => 'overview';

  @override
  String get personal => 'personal';

  @override
  String get assets => 'income from assets';

  @override
  String get pig => 'pig';

  @override
  String get chicken => 'chicken';

  @override
  String get goat => 'goat';

  @override
  String get error => 'error';

  @override
  String get cashAlert => 'not enough cash!';

  @override
  String get confirm => 'okay';

  @override
  String get howToPlay => 'How to Play';

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
      '5. You have to reach a certain cash amount to make it to the next level.';

  @override
  String get instructionText6 =>
      '6. You can find these game instructions in the settings menu.';

  @override
  String get warning => 'warning';

  @override
  String get investmentOptions => 'Investment Options';

  @override
  String get tip => 'tip';

  @override
  String get dontBuy => 'don\'t buy';

  @override
  String get payCash => 'pay cash';

  @override
  String get borrow => 'borrow';

  @override
  String get lostGame =>
      'unfortunately you ran out of cash. You can either restart this level or start a new game.';

  @override
  String get restartLevel => 'restart level';

  @override
  String get restartGame => 'restart game';

  @override
  String get settings => 'settings';

  @override
  String get clearCache => 'clear cache';

  @override
  String get nextLevel => 'next level';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName => 'please enter first and last name.';

  @override
  String get congratulations => 'congratulations';

  @override
  String get reachedNextLevel => 'you have reached the next level!';

  @override
  String get next => 'next';

  @override
  String get cash => 'cash';

  @override
  String get expenses => 'expenses';

  @override
  String get gameFinished =>
      'congratulations you finished the game successfully!';

  @override
  String get restart => 'restart';

  @override
  String get notMe => 'that\'s not me';

  @override
  String get signInDifferentPerson =>
      'if that is not you, please sign in as a different person.';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'loans',
      one: 'loan',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Price: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Income: $cashAmount per year';
  }

  @override
  String get income => 'income';

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
    return '• Interest rate on cash is $interestRate% / year';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'level $level / $levelTotal (Period: $period)';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'cash goal: reach $cashAmount';
  }

  @override
  String get languagesTitle => 'languages';

  @override
  String sameUser(String firstName) {
    return 'If you are $firstName, simply start the game.';
  }

  @override
  String startAtLevel(String level) {
    return 'start at level $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Welcome back, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Please select language:';

  @override
  String get hintUID => 'e.g. UGRT999';

  @override
  String get confirmNameTitle => 'Confirm your name';

  @override
  String confirmName(String firstName, String lastName) {
    return 'Are you $firstName $lastName?';
  }

  @override
  String get noButton => 'No';

  @override
  String get yesButton => 'Yes';

  @override
  String get codeNotFound => 'CODE NOT FOUND';

  @override
  String get noCodeButton => 'No code';

  @override
  String get signInName => 'Please sign in with your first and last name: \\n';

  @override
  String get backButton => 'Back';
}
