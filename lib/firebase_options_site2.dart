// Firebase config for Site 2 (finlitsim project) — second country deployment.
// Both Site 1 (ofinsen-dc06d) and Site 2 (finlitsim) are full production builds.
// To build for Site 2:  flutter build web --release --dart-define=FLAVOR=site2
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class Site2FirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return web;
      default:
        throw UnsupportedError(
          'Site2FirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Site 2 — finlitsim project
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAIfuLoevJOXxymYfHapg_Js3h31AxjNs',
    appId: '1:310545133265:web:fc3603fa61e99ecf761ff0',
    messagingSenderId: '310545133265',
    projectId: 'finlitsim',
    authDomain: 'finlitsim.firebaseapp.com',
    databaseURL: 'https://finlitsim-default-rtdb.firebaseio.com',
    storageBucket: 'finlitsim.firebasestorage.app',
    measurementId: 'G-15TKHFEHN3',
  );
}