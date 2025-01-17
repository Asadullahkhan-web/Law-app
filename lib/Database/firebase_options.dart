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
    apiKey: 'AIzaSyB0MBG0zHsT6uTs_qA04OgeXM4rmrNKSTA',
    appId: '1:939841215430:web:ccdcd90755cafd8d02b0c7',
    messagingSenderId: '939841215430',
    projectId: 'lawyerapp-e6856',
    authDomain: 'lawyerapp-e6856.firebaseapp.com',
    storageBucket: 'lawyerapp-e6856.appspot.com',
    measurementId: 'G-RT2NPRNCSV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz5sAxSqj8k77qYRyQ-xDD2mvVaksHIRs',
    appId: '1:939841215430:android:fbd2747c742fe29c02b0c7',
    messagingSenderId: '939841215430',
    projectId: 'lawyerapp-e6856',
    storageBucket: 'lawyerapp-e6856.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaVaZ5KLP8M2DyPVZjvUL4i1Gl7CzjHUE',
    appId: '1:939841215430:ios:750185272eaffe1502b0c7',
    messagingSenderId: '939841215430',
    projectId: 'lawyerapp-e6856',
    storageBucket: 'lawyerapp-e6856.appspot.com',
    iosBundleId: 'com.example.lawyersApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBaVaZ5KLP8M2DyPVZjvUL4i1Gl7CzjHUE',
    appId: '1:939841215430:ios:4a31348e04867d1c02b0c7',
    messagingSenderId: '939841215430',
    projectId: 'lawyerapp-e6856',
    storageBucket: 'lawyerapp-e6856.appspot.com',
    iosBundleId: 'com.example.lawyersApplication.RunnerTests',
  );
}
