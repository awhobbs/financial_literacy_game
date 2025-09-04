// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Español - GTQ';

  @override
  String get titleSignIn => 'Bienvenido al juego de Finsim';

  @override
  String get welcomeText =>
      'Queridos participantes, is Juego está destinado a imitar las inversiones financieras. Solo se utilizará con el fin de enseñar. Este juego no afectará la relación con su banco. \n \n Ingrese su información de contacto a continuación.';

  @override
  String get hintFirstName => 'nombre de pila';

  @override
  String get hintLastName => 'apellido';

  @override
  String get continueButton => 'continuar';

  @override
  String get overview => 'descripción general';

  @override
  String get personal => 'personal';

  @override
  String get assets => 'Ingresos de los activos';

  @override
  String get pig => 'vaca';

  @override
  String get chicken => 'pollo';

  @override
  String get goat => 'cabra';

  @override
  String get error => 'error';

  @override
  String get cashAlert => '¡No tiene suficiente efectivo!';

  @override
  String get confirm => 'de acuerdo';

  @override
  String get howToPlay => 'cómo jugar';

  @override
  String get instructionText1 =>
      '1. Para comenzar el juego, haga clic en el botón “Siguiente“ en la esquina superior derecha.';

  @override
  String get instructionText2 =>
      '2. Puede comprar un animal con efectivo, sacar un préstamo, o decidir no comprar el activo.';

  @override
  String get instructionText3 =>
      '3. Cada redondo animales varían en su precio, ingresos, y esperanza de vida.';

  @override
  String get instructionText4 =>
      '4. Es posible que encuentre útiles los cálculos debajo de la tarjeta de animales.';

  @override
  String get instructionText5 =>
      '5. Debe alcanzar una cierta cantidad en efectivo para llegar al siguiente nivel.';

  @override
  String get instructionText6 =>
      '6. Puedes encontrar estas instrucciones del juego en el menú Configuración.';

  @override
  String get warning => 'advertencia';

  @override
  String get investmentOptions => 'Opciones de inversión';

  @override
  String get tip => 'consejo';

  @override
  String get dontBuy => 'No comprar';

  @override
  String get payCash => 'pagar en efectivo';

  @override
  String get borrow => 'sacar un préstamo';

  @override
  String get lostGame =>
      'Desafortunadamente, te quedaste sin efectivo. Puedes reiniciar este nivel o comenzar un nuevo juego.';

  @override
  String get restartLevel => 'volver a empesar el nivel';

  @override
  String get restartGame => 'reinicia el juego';

  @override
  String get settings => 'ajustes';

  @override
  String get clearCache => 'limpiar cache';

  @override
  String get nextLevel => 'siguiente nivel';

  @override
  String get enterUID => 'please enter a 7 digit code';

  @override
  String get enterName => 'Por favor, introduzca su nombre y apellido.';

  @override
  String get congratulations => 'Felicitaciónes';

  @override
  String get reachedNextLevel => '¡Has alcanzado el siguiente nivel!';

  @override
  String get next => 'siguir';

  @override
  String get cash => 'pagar en efectivo';

  @override
  String get expenses => 'gastos';

  @override
  String get gameFinished => '¡Felicitaciones, terminaste el juego con éxito!';

  @override
  String get restart => 'Reanudar';

  @override
  String get notMe => 'ese no soy yo';

  @override
  String get signInDifferentPerson =>
      'Si ese no eres tú, por favor inicie sesión como una persona diferente.';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'préstamos',
      one: 'préstamo',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Precio: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Ingresos: $cashAmount / año';
  }

  @override
  String get income => 'ingreso';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'Esperanza de vida: $yearsNum años';
  }

  @override
  String lifeRisk(String number) {
    return 'Riesgo: 1 de $number no sobrevivirá';
  }

  @override
  String get cashGoal => 'Meta de efectivo';

  @override
  String assetDied(String asset) {
    return '$asset ha muerto!';
  }

  @override
  String get assetsDied => '¡Los animales han muerto!';

  @override
  String currentCash(String cashAmount) {
    return 'Efectivo actual: $cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'Tomar un préstamo al $interestRate% de interés total';
  }

  @override
  String interestCash(String interestRate) {
    return '• La tasa de interés en efectivo es $interestRate% / año';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'Nivel $level / $levelTotal';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'Meta de efectivo: alcanzar $cashAmount';
  }

  @override
  String get languagesTitle => 'Idiomas';

  @override
  String sameUser(String firstName) {
    return 'Si eres $firstName, simplemente comienza el juego.';
  }

  @override
  String startAtLevel(String level) {
    return 'Comience en el nivel $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Bienvenido de nuevo, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return '$value';
  }

  @override
  String get selectLanguage => 'Seleccione el idioma:';

  @override
  String get hintUID => 'p.ej. TEST001';

  @override
  String get confirmNameTitle => 'Confirma tu nombre';

  @override
  String confirmName(String firstName, String lastName) {
    return '¿Eres $firstName $lastName?';
  }

  @override
  String get noButton => 'No';

  @override
  String get yesButton => 'Sí';

  @override
  String get codeNotFound => 'Código no encontrado';

  @override
  String get noCodeButton => 'Sin código';

  @override
  String get signInName => 'Inicie sesión con su nombre y apellido: \n';

  @override
  String get backButton => 'atrás';
}

/// The translations for Spanish Castilian, as used in Guatemala (`es_GT`).
class AppLocalizationsEsGt extends AppLocalizationsEs {
  AppLocalizationsEsGt() : super('es_GT');

  @override
  String get language => 'Español - GTQ';

  @override
  String get titleSignIn => 'Bienvenido al juego de Finsim';

  @override
  String get welcomeText =>
      'Queridos participantes, is Juego está destinado a imitar las inversiones financieras. Solo se utilizará con el fin de enseñar. Este juego no afectará la relación con su banco. \n \n Ingrese su información de contacto a continuación.';

  @override
  String get hintFirstName => 'nombre de pila';

  @override
  String get hintLastName => 'apellido';

  @override
  String get continueButton => 'continuar';

  @override
  String get overview => 'descripción general';

  @override
  String get personal => 'personal';

  @override
  String get assets => 'Ingresos de los activos';

  @override
  String get pig => 'vaca';

  @override
  String get chicken => 'pollo';

  @override
  String get goat => 'cabra';

  @override
  String get error => 'error';

  @override
  String get cashAlert => '¡No tiene suficiente efectivo!';

  @override
  String get confirm => 'de acuerdo';

  @override
  String get howToPlay => 'cómo jugar';

  @override
  String get instructionText1 =>
      '1. Para comenzar el juego, haga clic en el botón “Siguiente“ en la esquina superior derecha.';

  @override
  String get instructionText2 =>
      '2. Puede comprar un animal con efectivo, sacar un préstamo, o decidir no comprar el activo.';

  @override
  String get instructionText3 =>
      '3. Cada redondo animales varían en su precio, ingresos, y esperanza de vida.';

  @override
  String get instructionText4 =>
      '4. Es posible que encuentre útiles los cálculos debajo de la tarjeta de animales.';

  @override
  String get instructionText5 =>
      '5. Debe alcanzar una cierta cantidad en efectivo para llegar al siguiente nivel.';

  @override
  String get instructionText6 =>
      '6. Puedes encontrar estas instrucciones del juego en el menú Configuración.';

  @override
  String get warning => 'advertencia';

  @override
  String get investmentOptions => 'Opciones de inversión';

  @override
  String get tip => 'consejo';

  @override
  String get dontBuy => 'No comprar';

  @override
  String get payCash => 'pagar en efectivo';

  @override
  String get borrow => 'sacar un préstamo';

  @override
  String get lostGame =>
      'Desafortunadamente, te quedaste sin efectivo. Puedes reiniciar este nivel o comenzar un nuevo juego.';

  @override
  String get restartLevel => 'volver a empesar el nivel';

  @override
  String get restartGame => 'reinicia el juego';

  @override
  String get settings => 'ajustes';

  @override
  String get clearCache => 'limpiar cache';

  @override
  String get nextLevel => 'siguiente nivel';

  @override
  String get enterName => 'Por favor, introduzca su nombre y apellido.';

  @override
  String get congratulations => 'Felicitaciónes';

  @override
  String get reachedNextLevel => '¡Has alcanzado el siguiente nivel!';

  @override
  String get next => 'siguir';

  @override
  String get cash => 'pagar en efectivo';

  @override
  String get expenses => 'gastos';

  @override
  String get gameFinished => '¡Felicitaciones, terminaste el juego con éxito!';

  @override
  String get restart => 'Reanudar';

  @override
  String get notMe => 'ese no soy yo';

  @override
  String get signInDifferentPerson =>
      'Si ese no eres tú, por favor inicie sesión como una persona diferente.';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'préstamos',
      one: 'préstamo',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Precio: $cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Ingresos: $cashAmount / año';
  }

  @override
  String get income => 'ingreso';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'Esperanza de vida: $yearsNum años';
  }

  @override
  String lifeRisk(String number) {
    return 'Riesgo: 1 de $number no sobrevivirá';
  }

  @override
  String get cashGoal => 'Meta de efectivo';

  @override
  String assetDied(String asset) {
    return '$asset ha muerto!';
  }

  @override
  String get assetsDied => '¡Los animales han muerto!';

  @override
  String currentCash(String cashAmount) {
    return 'Efectivo actual: $cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'Tomar un préstamo al $interestRate% de interés total';
  }

  @override
  String interestCash(String interestRate) {
    return '• La tasa de interés en efectivo es $interestRate% / año';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'Nivel $level / $levelTotal';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'Meta de efectivo: alcanzar $cashAmount';
  }

  @override
  String get languagesTitle => 'Idiomas';

  @override
  String sameUser(String firstName) {
    return 'Si eres $firstName, simplemente comienza el juego.';
  }

  @override
  String startAtLevel(String level) {
    return 'Comience en el nivel $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Bienvenido de nuevo, $firstName $lastName!';
  }

  @override
  String get selectLanguage => 'Seleccione el idioma:';

  @override
  String get hintUID => 'p.ej. TEST001';

  @override
  String get confirmNameTitle => 'Confirma tu nombre';

  @override
  String confirmName(String firstName, String lastName) {
    return '¿Eres $firstName $lastName?';
  }

  @override
  String get noButton => 'No';

  @override
  String get yesButton => 'Sí';

  @override
  String get codeNotFound => 'Código no encontrado';

  @override
  String get noCodeButton => 'Sin código';

  @override
  String get signInName => 'Inicie sesión con su nombre y apellido: \n';

  @override
  String get backButton => 'atrás';
}

/// The translations for Spanish Castilian, as used in Peru (`es_PE`).
class AppLocalizationsEsPe extends AppLocalizationsEs {
  AppLocalizationsEsPe() : super('es_PE');

  @override
  String get language => 'Español - PEN';

  @override
  String get titleSignIn => 'Bienvenido al juego de Finsim';

  @override
  String get welcomeText =>
      'Queridos participantes, este Juego está destinado a imitar inversiones financieras. Solo se utilizará con propósitos educativos. Este juego no afectará la relación con su banco. \n \n Ingrese su información de contacto a continuación.';

  @override
  String get hintFirstName => 'Nombre';

  @override
  String get hintLastName => 'Apellido';

  @override
  String get continueButton => 'Continuar';

  @override
  String get overview => 'Descripción general';

  @override
  String get personal => 'Personal';

  @override
  String get assets => 'Ingresos de los activos';

  @override
  String get pig => 'cerdo';

  @override
  String get chicken => 'pollo';

  @override
  String get goat => 'cabra';

  @override
  String get error => 'error';

  @override
  String get cashAlert => '¡No tiene suficiente efectivo!';

  @override
  String get confirm => 'Acceptar';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get instructionText1 =>
      '1. Para comenzar el juego, haga clic en el botón “Siguiente“ en la esquina superior derecha.';

  @override
  String get instructionText2 =>
      '2. Puedes decidir comprar un animal con efectivo, sacar un préstamo, o no comprar el activo.';

  @override
  String get instructionText3 =>
      '3. Cada oferta de animales varía en su precio, ingresos, y esperanza de vida.';

  @override
  String get instructionText4 =>
      '4. Es posible que encuentre útiles los cálculos debajo de la tarjeta de animales.';

  @override
  String get instructionText5 =>
      '5. Debe alcanzar una cantidad en efectivo determinada para llegar al siguiente nivel.';

  @override
  String get instructionText6 =>
      '6. Puedes encontrar estas instrucciones del juego en el menú de Configuración.';

  @override
  String get warning => 'Advertencia';

  @override
  String get investmentOptions => 'Opciones de inversión';

  @override
  String get tip => 'Consejo';

  @override
  String get dontBuy => 'No comprar';

  @override
  String get payCash => 'Pagar en efectivo';

  @override
  String get borrow => 'Sacar un préstamo';

  @override
  String get lostGame =>
      'Desafortunadamente, te quedaste sin efectivo. Puedes reiniciar este nivel o comenzar un nuevo juego.';

  @override
  String get restartLevel => 'Volver a empezar el nivel';

  @override
  String get restartGame => 'Reiniciar el juego';

  @override
  String get settings => 'Ajustes';

  @override
  String get clearCache => 'Limpiar cache';

  @override
  String get nextLevel => 'Siguiente nivel';

  @override
  String get enterName => 'Por favor, introduzca su nombre y apellido.';

  @override
  String get congratulations => 'Felicitaciónes';

  @override
  String get reachedNextLevel => '¡Has alcanzado el siguiente nivel!';

  @override
  String get next => 'Seguir';

  @override
  String get cash => 'Pagar en efectivo';

  @override
  String get expenses => 'gastos';

  @override
  String get gameFinished => '¡Felicitaciones, terminaste el juego con éxito!';

  @override
  String get restart => 'Reanudar';

  @override
  String get notMe => 'Ese no soy yo';

  @override
  String get signInDifferentPerson =>
      'Si ese no eres tú, por favor reinicia sesión con un usuario diferente.';

  @override
  String loan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'préstamos',
      one: 'préstamo',
    );
    return '$_temp0';
  }

  @override
  String price(String cashAmount) {
    return 'Precio: S/$cashAmount';
  }

  @override
  String incomePerYear(String cashAmount) {
    return 'Ingresos: S/$cashAmount per año';
  }

  @override
  String get income => 'Ingreso';

  @override
  String lifeExpectancy(int yearsNum) {
    return 'Esperanza de vida: $yearsNum años';
  }

  @override
  String lifeRisk(String number) {
    return 'Riesgo: 1 de $number no sobrevivirá';
  }

  @override
  String get cashGoal => 'Meta de efectivo';

  @override
  String assetDied(String asset) {
    return '$asset Ha muerto!';
  }

  @override
  String get assetsDied => '¡Los animales han muerto!';

  @override
  String currentCash(String cashAmount) {
    return 'Efectivo disponible: S/$cashAmount';
  }

  @override
  String borrowAt(String interestRate) {
    return 'Tomar un préstamo al $interestRate% de interés total';
  }

  @override
  String interestCash(String interestRate) {
    return '• La tasa de interés en efectivo es $interestRate% / año';
  }

  @override
  String level(int level, int levelTotal, Object period) {
    return 'Nivel $level / $levelTotal (Período: $period)';
  }

  @override
  String cashGoalReach(String cashAmount) {
    return 'Meta de efectivo: alcanzar S/$cashAmount';
  }

  @override
  String get languagesTitle => 'Idiomas';

  @override
  String sameUser(String firstName) {
    return 'Si eres $firstName, simplemente comienza el juego.';
  }

  @override
  String startAtLevel(String level) {
    return 'Comience en el nivel $level';
  }

  @override
  String welcomeBack(String firstName, String lastName) {
    return 'Bienvenido de nuevo, $firstName $lastName!';
  }

  @override
  String cashValue(String value) {
    return 'S/$value';
  }

  @override
  String get selectLanguage => 'Seleccione el idioma:';

  @override
  String get hintUID => 'p.ej. TEST001';

  @override
  String get confirmNameTitle => 'Confirma tu nombre';

  @override
  String confirmName(String firstName, String lastName) {
    return '¿Eres $firstName $lastName?';
  }

  @override
  String get noButton => 'No';

  @override
  String get yesButton => 'Sí';

  @override
  String get codeNotFound => 'Código no encontrado';

  @override
  String get noCodeButton => 'Sin código';

  @override
  String get signInName => 'Inicie sesión con su nombre y apellido: \n';

  @override
  String get backButton => 'Atrás';
}
