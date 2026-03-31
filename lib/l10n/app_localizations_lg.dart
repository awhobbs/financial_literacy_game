// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ganda Luganda (`lg`).
class AppLocalizationsLg extends AppLocalizations {
  AppLocalizationsLg([String locale = 'lg']) : super(locale);

  @override
  String get language => 'Oluganda - UGX';

  @override
  String get titleSignIn => 'Nkwanilizza ku kazannyo kano akayitibwa FinSim';

  @override
  String get welcomeText =>
      'Munaffe omuzannyi, akazannyo kano kagezako kwefananyiliza byanfuna era kajja kozesebwa mu kusomesa kwoka. Okuzannya akazannyo kano tekijja kubaako kyekikyuusa mu nkolagana wakatiwo ne Bank yyo. Nkusaba otekemu ebikukwatako wansi';

  @override
  String get hintFirstName => 'Elinya elisooka';

  @override
  String get hintLastName => 'Elinya eddala';

  @override
  String get continueButton => 'Weyongereyo';

  @override
  String get overview => 'mubufuunze';

  @override
  String get personal => 'Ebyange';

  @override
  String get assets => 'enyingizza eva mu ky\'oguze';

  @override
  String get pig => 'pig';

  @override
  String get chicken => 'Enkoko';

  @override
  String get goat => 'Embuzi';

  @override
  String get error => 'Ensobi';

  @override
  String get cashAlert => 'Sente zolinawo tezimala';

  @override
  String get confirm => 'tandika okuzannya';

  @override
  String get howToPlay => 'Engeri y\'okuzannya';

  @override
  String get instructionText1 =>
      '1. Okutandika okuzanya,nyiga wolaba akagambo “EKIDDAKKO“ wagulu ku mukono gwa ddyo';

  @override
  String get instructionText2 =>
      '2. Osobola okugula ekisolo nga okozesa sente z\'olinawo, oba nga wewola oba oyinza okusalawo obutagula';

  @override
  String get instructionText3 =>
      '3. Buli luzannya,ebisolo bikyuka ebeeyi, sente z\'ebiyingiza n\'ebanga lyebimala nga bilamu';

  @override
  String get instructionText4 =>
      '4. Ebibalo ebili wansi w\'ekisolo biyinza okubeera eby\'omugasso jooli';

  @override
  String get instructionText5 =>
      '5. Olina okuweza omuwendo gwa sente ogwesalila okusobola okweyongerayo ku mutendera ogudako';

  @override
  String get instructionText6 =>
      '6. Osobola okusanga engeri zino  ez\'okuzannya akazannyo kano bwokebeera mu nteekateeka';

  @override
  String get warning => 'Okukulaalika';

  @override
  String get investmentOptions => 'Ky\'osobola okugula';

  @override
  String get tip => 'Ekibalo';

  @override
  String get dontBuy => 'Togula';

  @override
  String get payCash => 'Gula';

  @override
  String get borrow => 'okwewola';

  @override
  String get lostGame =>
      'ekibi sente zikuweddeko. Osobola okuddamu omutendeera guno gwenyini oba okudayo n\'otandikila akazannyo jekatandikila.';

  @override
  String get restartLevel => 'Ddamu omutendeera guno';

  @override
  String get restartGame => 'Ddamu akazannyo okuva ku ntandikwa';

  @override
  String get settings => 'Enteekateeka';

  @override
  String get clearCache => 'jamu ebilimu';

  @override
  String get nextLevel => 'omutendeera oguddako';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName =>
      'Teekamu elinya lyo elisooka n\'elinya lyo ely\'okubiri';

  @override
  String get congratulations => 'Tukuyozayozza';

  @override
  String get reachedNextLevel => 'Otuuse ku mutendeera oguddako';

  @override
  String get next => 'ekiddako';

  @override
  String get cash => 'Sente';

  @override
  String get expenses => 'Ebisale';

  @override
  String get gameFinished => 'Tukuyozayozza okumalayo akazannyo obulunji';

  @override
  String get restart => 'Ddamu';

  @override
  String get notMe => 'oyo ssi nze';

  @override
  String get signInDifferentPerson => 'sasuzza sente zolinawo';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ebanja',
      one: 'Ebanja',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Ebeeyi: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Enfunna: $cashAmount / buli mwaka';
  }

  @override
  String get income => 'Enfunna';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'Kiwangalila: emyaka $yearsNum';
  }

  @override
  String lifeRisk(String number) {
    return 'ekisobola okugwawo: 1 ku $number ejja kuffa';
  }

  @override
  String get cashGoal => 'Sente zolina okuwezza';

  @override
  String assetDied(String asset) {
    return '$asset kifudde';
  }

  @override
  String get assetsDied => 'Ensolozzo zifudde';

  @override
  String currentCash(String cashAmount) {
    return 'Sente zolinawo: $cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'wewole ku $interestRate% omugate gw\'amagoba';
  }

  @override
  String interestCash(String interestRate) {
    return 'Amagoba singa ogula nga okozesa sente zolina gali $interestRate% / buli mwaka';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'Omutendeera $level / $levelTotal';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'Sente zolina okuwezza : Wezza $cashAmount';
  }

  @override
  String get languagesTitle => 'Enimi';

  @override
  String sameUser(String firstName) {
    return 'Bwoba nga yegwe $firstName, tandika akazannyo';
  }

  @override
  String startAtLevel(String level) {
    return 'Tandikala kumutedeera $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Webale kukomawo, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Nsaba olondeko olulimi lwo:';

  @override
  String get hintUID => 'ennamba y’omukozesa. e.g. UGRT999';

  @override
  String get confirmNameTitle => 'Kakasa erinnya lyo';

  @override
  String confirmName(String firstName, String lastName) {
    return 'Are you $firstName $lastName?';
  }

  @override
  String get noButton => 'Nedda';

  @override
  String get yesButton => 'Yee';

  @override
  String get codeNotFound => 'Koodi tezuuliddwa';

  @override
  String get noCodeButton => 'Tewali koodi';

  @override
  String get signInName =>
      'Nsaba oyingire ne\'linyalyo elisooka ne\'liddako: \n';

  @override
  String get backButton => 'Okukomawo';
}
