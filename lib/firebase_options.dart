// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC5YTPn143WLFeZ4P8f7zc3hj2OUVP_I28',
    appId: '1:649331119705:web:c5b15f59a5fb38b7c54348',
    messagingSenderId: '649331119705',
    projectId: 'quickvid-8d439',
    authDomain: 'quickvid-8d439.firebaseapp.com',
    storageBucket: 'quickvid-8d439.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtYYpQOpTaJewGpbX7pLL67nDsBK4BEac',
    appId: '1:649331119705:android:dd710c39b8f54966c54348',
    messagingSenderId: '649331119705',
    projectId: 'quickvid-8d439',
    storageBucket: 'quickvid-8d439.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUbvZrFNS_48rGqIZ_Axaqwkurb7gMrb0',
    appId: '1:649331119705:ios:b3800effeb577a77c54348',
    messagingSenderId: '649331119705',
    projectId: 'quickvid-8d439',
    storageBucket: 'quickvid-8d439.firebasestorage.app',
    iosBundleId: 'com.example.quickVid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUbvZrFNS_48rGqIZ_Axaqwkurb7gMrb0',
    appId: '1:649331119705:ios:b3800effeb577a77c54348',
    messagingSenderId: '649331119705',
    projectId: 'quickvid-8d439',
    storageBucket: 'quickvid-8d439.firebasestorage.app',
    iosBundleId: 'com.example.quickVid',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC5YTPn143WLFeZ4P8f7zc3hj2OUVP_I28',
    appId: '1:649331119705:web:0dda70b7723796adc54348',
    messagingSenderId: '649331119705',
    projectId: 'quickvid-8d439',
    authDomain: 'quickvid-8d439.firebaseapp.com',
    storageBucket: 'quickvid-8d439.firebasestorage.app',
  );
}