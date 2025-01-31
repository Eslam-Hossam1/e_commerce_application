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
    apiKey: 'AIzaSyCM2BspHLpzZHCYO1EHuL0I3UUpq6_eZMc',
    appId: '1:769616262458:web:0ffaf8d57b5f230db5cc03',
    messagingSenderId: '769616262458',
    projectId: 'e-commerce-app-2af68',
    authDomain: 'e-commerce-app-2af68.firebaseapp.com',
    storageBucket: 'e-commerce-app-2af68.appspot.com',
    measurementId: 'G-BXPTLCW52K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOUxiwDnvzllF33WUCwsnTD0iP6jwKRiE',
    appId: '1:769616262458:android:edad8deb47454e8cb5cc03',
    messagingSenderId: '769616262458',
    projectId: 'e-commerce-app-2af68',
    storageBucket: 'e-commerce-app-2af68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2Uf2Sc_TwOY4Bqza7ZuuQNcRTe7FHZHY',
    appId: '1:769616262458:ios:be76b206cc0e4bc2b5cc03',
    messagingSenderId: '769616262458',
    projectId: 'e-commerce-app-2af68',
    storageBucket: 'e-commerce-app-2af68.appspot.com',
    iosBundleId: 'com.example.eCommerceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2Uf2Sc_TwOY4Bqza7ZuuQNcRTe7FHZHY',
    appId: '1:769616262458:ios:be76b206cc0e4bc2b5cc03',
    messagingSenderId: '769616262458',
    projectId: 'e-commerce-app-2af68',
    storageBucket: 'e-commerce-app-2af68.appspot.com',
    iosBundleId: 'com.example.eCommerceApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCM2BspHLpzZHCYO1EHuL0I3UUpq6_eZMc',
    appId: '1:769616262458:web:c9733fbeb7ac916ab5cc03',
    messagingSenderId: '769616262458',
    projectId: 'e-commerce-app-2af68',
    authDomain: 'e-commerce-app-2af68.firebaseapp.com',
    storageBucket: 'e-commerce-app-2af68.appspot.com',
    measurementId: 'G-41RP0LVCHS',
  );
}
