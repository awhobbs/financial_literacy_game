// Firebase config for the tester deployment (ofinsen-dc06d project)
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class TesterFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return web; // web config works for all platforms in tester builds
      default:
        throw UnsupportedError(
          'TesterFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8DqDsRyzJOIEjCuW33Oma3opvYTVEt2Y',
    appId: '1:127466888848:web:b4aad6e36dbe143e474215',
    messagingSenderId: '127466888848',
    projectId: 'ofinsen-dc06d',
    authDomain: 'ofinsen-dc06d.firebaseapp.com',
    storageBucket: 'ofinsen-dc06d.firebasestorage.app',
    measurementId: 'G-BLD47S9Q3Z',
  );
}