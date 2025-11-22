import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FallbackMaterialLocalizations extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizations();
  static const delegate = FallbackMaterialLocalizations();
  @override bool isSupported(Locale locale) => true;
  @override Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  @override bool shouldReload(FallbackMaterialLocalizations old) => false;
}

class FallbackWidgetsLocalizations extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizations();
  static const delegate = FallbackWidgetsLocalizations();
  @override bool isSupported(Locale locale) => true;
  @override Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('en'));
  @override bool shouldReload(FallbackWidgetsLocalizations old) => false;
}

class FallbackCupertinoLocalizations extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizations();
  static const delegate = FallbackCupertinoLocalizations();
  @override bool isSupported(Locale locale) => true;
  @override Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.delegate.load(const Locale('en'));
  @override bool shouldReload(FallbackCupertinoLocalizations old) => false;
}