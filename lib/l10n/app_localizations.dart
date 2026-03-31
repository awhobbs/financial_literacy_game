import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ach.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_lg.dart';
import 'app_localizations_nyn.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ach'),
    Locale('en'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('es', 'GT'),
    Locale('es', 'PE'),
    Locale('kn'),
    Locale('lg'),
    Locale('nyn')
  ];

  /// The current Language
  ///
  /// In en, this message translates to:
  /// **'English - USD'**
  String get language;

  /// Welcoming users to the Game
  ///
  /// In en, this message translates to:
  /// **'welcome to the FinSim Game'**
  String get titleSignIn;

  /// welcome instructions for users when opening the app
  ///
  /// In en, this message translates to:
  /// **'Dear participants,\nthis game is meant to mimic financial investments. It will only be used for the purpose of teaching. This game will not affect the relationship with your bank.\nPlease enter your code below:'**
  String get welcomeText;

  /// Hint text for user to enter the first name
  ///
  /// In en, this message translates to:
  /// **'first name'**
  String get hintFirstName;

  /// Hint text for user to enter the last name
  ///
  /// In en, this message translates to:
  /// **'last name'**
  String get hintLastName;

  /// Button after user entered name to continue to play
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get continueButton;

  /// Title for overview section of financial situation
  ///
  /// In en, this message translates to:
  /// **'overview'**
  String get overview;

  /// Title for overview section of personal expenses. Currently not used in app
  ///
  /// In en, this message translates to:
  /// **'personal'**
  String get personal;

  /// Title for overview section of assets that the user owns and income they generate
  ///
  /// In en, this message translates to:
  /// **'income from assets'**
  String get assets;

  /// Asset pig that user can buy
  ///
  /// In en, this message translates to:
  /// **'pig'**
  String get pig;

  /// Asset chicken that user can buy
  ///
  /// In en, this message translates to:
  /// **'chicken'**
  String get chicken;

  /// Asset goat that user can buy
  ///
  /// In en, this message translates to:
  /// **'goat'**
  String get goat;

  /// error alert when user does not have enough cash
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// warning message that user does not have enough cash
  ///
  /// In en, this message translates to:
  /// **'not enough cash!'**
  String get cashAlert;

  /// asks user to confirm with okay
  ///
  /// In en, this message translates to:
  /// **'okay'**
  String get confirm;

  /// Title that tells people how to play the game
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// First instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'1. To start the game click the “NEXT” button in the top right corner.'**
  String get instructionText1;

  /// Second instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'2. You can buy an animal with cash, take a loan or decide not to buy the asset.'**
  String get instructionText2;

  /// Third instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'3. Each round animals vary in price, income and life expectancy.'**
  String get instructionText3;

  /// Fourth instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'4. You might find the calculations underneath the animal card helpful.'**
  String get instructionText4;

  /// Fifth instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'5. You have to reach a certain cash amount to make it to the next level.'**
  String get instructionText5;

  /// Sixth instruction on how to play the game
  ///
  /// In en, this message translates to:
  /// **'6. You can find these game instructions in the settings menu.'**
  String get instructionText6;

  /// title of warning dialog
  ///
  /// In en, this message translates to:
  /// **'warning'**
  String get warning;

  /// title to show investment options
  ///
  /// In en, this message translates to:
  /// **'Investment Options'**
  String get investmentOptions;

  /// tip that is displayed for users
  ///
  /// In en, this message translates to:
  /// **'tip'**
  String get tip;

  /// option for user to not buy asset
  ///
  /// In en, this message translates to:
  /// **'don\'\'t buy'**
  String get dontBuy;

  /// option for user to buy asset in cash
  ///
  /// In en, this message translates to:
  /// **'pay cash'**
  String get payCash;

  /// option for user to buy asset via loan
  ///
  /// In en, this message translates to:
  /// **'borrow'**
  String get borrow;

  /// warning message when the user lost because they ran out of cash
  ///
  /// In en, this message translates to:
  /// **'unfortunately you ran out of cash. You can either restart this level or start a new game.'**
  String get lostGame;

  /// start level again after losing
  ///
  /// In en, this message translates to:
  /// **'restart level'**
  String get restartLevel;

  /// start game again after restarting app
  ///
  /// In en, this message translates to:
  /// **'restart game'**
  String get restartGame;

  /// settings option for user
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settings;

  /// clearing cache from local device
  ///
  /// In en, this message translates to:
  /// **'clear cache'**
  String get clearCache;

  /// allows user to advance to next level. Only used for testing
  ///
  /// In en, this message translates to:
  /// **'next level'**
  String get nextLevel;

  /// Hint text for user to enter their 7 digit code
  ///
  /// In en, this message translates to:
  /// **'please enter a 7 digit code'**
  String get enterUID;

  /// Hint text for user to enter their first and last name
  ///
  /// In en, this message translates to:
  /// **'please enter first and last name.'**
  String get enterName;

  /// Congratulations dialog after user completed level
  ///
  /// In en, this message translates to:
  /// **'congratulations'**
  String get congratulations;

  /// Message when user completed level
  ///
  /// In en, this message translates to:
  /// **'you have reached the next level!'**
  String get reachedNextLevel;

  /// next button text
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// pay with cash
  ///
  /// In en, this message translates to:
  /// **'cash'**
  String get cash;

  /// expenses per period
  ///
  /// In en, this message translates to:
  /// **'expenses'**
  String get expenses;

  /// dialog when user finished the game
  ///
  /// In en, this message translates to:
  /// **'congratulations you finished the game successfully!'**
  String get gameFinished;

  /// restart the game button
  ///
  /// In en, this message translates to:
  /// **'restart'**
  String get restart;

  /// indicating that it's another user playing the game
  ///
  /// In en, this message translates to:
  /// **'that\'\'s not me'**
  String get notMe;

  /// Text in welcome back screen indicating if another user plays the game
  ///
  /// In en, this message translates to:
  /// **'if that is not you, please sign in as a different person.'**
  String get signInDifferentPerson;

  /// Translate loan and loans in brackets to be used
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{loan} other{loans}}'**
  String loan(num count);

  /// Price for asset
  ///
  /// In en, this message translates to:
  /// **'price: {cashAmount}'**
  String price(String cashAmount);

  /// Income per period for asset
  ///
  /// In en, this message translates to:
  /// **'income: {cashAmount} / year'**
  String incomePerYear(String cashAmount);

  /// title using income
  ///
  /// In en, this message translates to:
  /// **'income'**
  String get income;

  /// how long an asset will live
  ///
  /// In en, this message translates to:
  /// **'life expectancy: {yearsNum} years'**
  String lifeExpectancy(int yearsNum);

  /// risk level described as one out of number will not survive
  ///
  /// In en, this message translates to:
  /// **'risk: 1 out of {number} will not survive'**
  String lifeRisk(String number);

  /// cash that player needs to accumulate to advance to next level
  ///
  /// In en, this message translates to:
  /// **'cash goal'**
  String get cashGoal;

  /// dialog when the asset has died
  ///
  /// In en, this message translates to:
  /// **'{asset} has died!'**
  String assetDied(String asset);

  /// dialog when the assets have died
  ///
  /// In en, this message translates to:
  /// **'animals have died!'**
  String get assetsDied;

  /// displays the current amount of cash a user has
  ///
  /// In en, this message translates to:
  /// **'your current cash: {cashAmount}'**
  String currentCash(String cashAmount);

  /// displays at which interest rate the user can borrow money. E.g borrow at 12% interest rate
  ///
  /// In en, this message translates to:
  /// **'borrow at {interestRate}% simple interest over 2 periods'**
  String borrowAt(String interestRate);

  /// Interest rate on cash when saving, not used right now
  ///
  /// In en, this message translates to:
  /// **'• Interest rate on cash is {interestRate}% / year'**
  String interestCash(String interestRate);

  /// Level which user is in out of all levels
  ///
  /// In en, this message translates to:
  /// **'level {level} / {levelTotal}'**
  String level(int level, int levelTotal, Object period);

  /// Cash goal that user needs to reach
  ///
  /// In en, this message translates to:
  /// **'cash goal: reach {cashAmount} '**
  String cashGoalReach(String cashAmount);

  /// Title in Language setting
  ///
  /// In en, this message translates to:
  /// **'languages'**
  String get languagesTitle;

  /// No description provided for @sameUser.
  ///
  /// In en, this message translates to:
  /// **'If you are {firstName}, simply start the game.'**
  String sameUser(String firstName);

  /// At which level the user can start the game
  ///
  /// In en, this message translates to:
  /// **'start at level {level}'**
  String startAtLevel(String level);

  /// Welcomes back user e.g Welcome back, John Doe
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {firstName} {lastName}!'**
  String welcomeBack(String firstName, String lastName);

  /// How cash values are displayed in App
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String cashValue(String value);

  /// Dialog when asking user about language
  ///
  /// In en, this message translates to:
  /// **'Please select language:'**
  String get selectLanguage;

  /// Hint text for user to enter their UID, for example XH5YT
  ///
  /// In en, this message translates to:
  /// **'e.g. UGRT999'**
  String get hintUID;

  /// Ask user to confirm their name
  ///
  /// In en, this message translates to:
  /// **'Confirm your name'**
  String get confirmNameTitle;

  /// Display User name to confirm
  ///
  /// In en, this message translates to:
  /// **'Are you {firstName} {lastName}?'**
  String confirmName(String firstName, String lastName);

  /// No button in dialog
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noButton;

  /// Yes button in dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesButton;

  /// If the entered code is not in database
  ///
  /// In en, this message translates to:
  /// **'CODE NOT FOUND'**
  String get codeNotFound;

  /// no code available for user, e.g tester
  ///
  /// In en, this message translates to:
  /// **'No code'**
  String get noCodeButton;

  /// sign in with first and last name when no code available
  ///
  /// In en, this message translates to:
  /// **'Please sign in with your first and last name: \n'**
  String get signInName;

  /// back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ach',
        'en',
        'es',
        'kn',
        'lg',
        'nyn'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case 'GT':
            return AppLocalizationsEsGt();
          case 'PE':
            return AppLocalizationsEsPe();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ach':
      return AppLocalizationsAch();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'kn':
      return AppLocalizationsKn();
    case 'lg':
      return AppLocalizationsLg();
    case 'nyn':
      return AppLocalizationsNyn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
