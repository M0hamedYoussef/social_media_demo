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
    apiKey: 'my_apikey',
    appId: '1:191749860979:web:14430e937c48db31b0c406',
    messagingSenderId: '191749860979',
    projectId: 'chat-b06e1',
    authDomain: 'chat-b06e1.firebaseapp.com',
    databaseURL: 'https://chat-b06e1-default-rtdb.firebaseio.com',
    storageBucket: 'chat-b06e1.appspot.com',
    measurementId: 'G-DX5R15HV2K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'my_apikey',
    appId: '1:191749860979:android:502972fd0aee14c0b0c406',
    messagingSenderId: '191749860979',
    projectId: 'chat-b06e1',
    databaseURL: 'https://chat-b06e1-default-rtdb.firebaseio.com',
    storageBucket: 'chat-b06e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'my_apikey',
    appId: '1:191749860979:ios:33c99b2cd700c6aab0c406',
    messagingSenderId: '191749860979',
    projectId: 'chat-b06e1',
    databaseURL: 'https://chat-b06e1-default-rtdb.firebaseio.com',
    storageBucket: 'chat-b06e1.appspot.com',
    androidClientId: '191749860979-gnplj9vi5sq6266f8mploe78imhbvh5b.apps.googleusercontent.com',
    iosClientId: '191749860979-u8dtjjjb76cbctf5rgfrcurqnotp2rgt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppSecond',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'my_apikey',
    appId: '1:191749860979:ios:33c99b2cd700c6aab0c406',
    messagingSenderId: '191749860979',
    projectId: 'chat-b06e1',
    databaseURL: 'https://chat-b06e1-default-rtdb.firebaseio.com',
    storageBucket: 'chat-b06e1.appspot.com',
    androidClientId: '191749860979-gnplj9vi5sq6266f8mploe78imhbvh5b.apps.googleusercontent.com',
    iosClientId: '191749860979-u8dtjjjb76cbctf5rgfrcurqnotp2rgt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppSecond',
  );
}
