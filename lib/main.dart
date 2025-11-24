import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

// Firebase options
import 'firebase_options.dart';

// App core
import 'config/constants.dart';
import 'config/themes.dart';
import 'domain/game_data_notifier.dart';

// Localization
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'l10n/fallback_localizations.dart';

// Offline modules
import 'offline/offline_sync.dart';

// Screens
import 'presentation/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ----------------------------
  /// 1. Firebase initialization
  /// ----------------------------
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// ----------------------------
  /// 2. Start background offline sync worker
  /// ----------------------------
  ///
  /// We cannot start until we know the user UID,
  /// so Sync starts later inside login (sign-in dialog).
  ///
  /// Just leave this line commented:
  ///
  /// OfflineSync.startWorker(uid);
  ///
  /// No init() and no syncPending() anymore.

  /// ----------------------------
  /// 3. Run App
  /// ----------------------------
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(gameDataNotifierProvider).locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,

      locale: locale,
      localeResolutionCallback: (systemLocale, supportedLocales) {
        return systemLocale ?? const Locale('en');
      },

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

        // Fallback for missing translations
        FallbackMaterialLocalizations.delegate,
        FallbackWidgetsLocalizations.delegate,
        FallbackCupertinoLocalizations.delegate,
      ],

      supportedLocales: L10n.all,

      home: const Homepage(),
    );
  }
}
