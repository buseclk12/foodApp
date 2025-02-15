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
    apiKey: 'AIzaSyBWwT4_qBgkOw8rIQKTJlL6xi4wiAxazDY',
    appId: '1:871285282082:web:9246f8c44dff04546f817b',
    messagingSenderId: '871285282082',
    projectId: 'foodtrackdbctis470',
    authDomain: 'foodtrackdbctis470.firebaseapp.com',
    storageBucket: 'foodtrackdbctis470.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNLN4O2srYQMOFiZkPKmmXlo4MwDaXQyA',
    appId: '1:871285282082:android:5ed05910da1a114e6f817b',
    messagingSenderId: '871285282082',
    projectId: 'foodtrackdbctis470',
    storageBucket: 'foodtrackdbctis470.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqr9DRpWm2UtmNWJoBdYIsD62ViDz9-xY',
    appId: '1:871285282082:ios:7951bc24c71f3f736f817b',
    messagingSenderId: '871285282082',
    projectId: 'foodtrackdbctis470',
    storageBucket: 'foodtrackdbctis470.appspot.com',
    iosBundleId: 'com.example.foodTrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqr9DRpWm2UtmNWJoBdYIsD62ViDz9-xY',
    appId: '1:871285282082:ios:fa00757fc72470086f817b',
    messagingSenderId: '871285282082',
    projectId: 'foodtrackdbctis470',
    storageBucket: 'foodtrackdbctis470.appspot.com',
    iosBundleId: 'com.example.foodTrack.RunnerTests',
  );
}
