import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'firebase_options_tester.dart';
import 'config/themes.dart';
import 'config/constants.dart';
import 'l10n/l10n.dart';
import 'l10n/app_localizations.dart';
import 'l10n/fallback_localizations.dart';

import 'domain/game_data_notifier.dart';
import 'presentation/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'production');
  await Firebase.initializeApp(
    options: flavor == 'tester'
        ? TesterFirebaseOptions.currentPlatform
        : DefaultFirebaseOptions.currentPlatform,
  );

  // Session data is preserved across launches so players can resume their progress
  // Data is only cleared when a user explicitly logs out or switches accounts

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: ref.watch(gameDataNotifierProvider).locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        FallbackMaterialLocalizations.delegate,
        FallbackCupertinoLocalizations.delegate,
        FallbackWidgetsLocalizations.delegate,
      ],
      home: const Homepage(),
    );
  }
}
