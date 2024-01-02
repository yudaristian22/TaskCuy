// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJYnextb8Rjme1vvcky8lqE-ICqGUsB0U',
    appId: '1:1095474609953:web:08ddb65d3acc77ee0dc860',
    messagingSenderId: '1095474609953',
    projectId: 'taskcuy-a5673',
    authDomain: 'taskcuy-a5673.firebaseapp.com',
    storageBucket: 'taskcuy-a5673.appspot.com',
    measurementId: 'G-S4N4052XRM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYSv76oUPQm1lHnDRCoMu1PAmlsO9C2R8',
    appId: '1:1095474609953:android:f9965ef03abbb8b50dc860',
    messagingSenderId: '1095474609953',
    projectId: 'taskcuy-a5673',
    storageBucket: 'taskcuy-a5673.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0bQWbv5LEuZhBba8cvXKS_E0wMFVGoWE',
    appId: '1:1095474609953:ios:e38efa05c11beee90dc860',
    messagingSenderId: '1095474609953',
    projectId: 'taskcuy-a5673',
    storageBucket: 'taskcuy-a5673.appspot.com',
    iosBundleId: 'com.example.taskcuy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0bQWbv5LEuZhBba8cvXKS_E0wMFVGoWE',
    appId: '1:1095474609953:ios:d192124dce2382ce0dc860',
    messagingSenderId: '1095474609953',
    projectId: 'taskcuy-a5673',
    storageBucket: 'taskcuy-a5673.appspot.com',
    iosBundleId: 'com.example.taskcuy.RunnerTests',
  );
}