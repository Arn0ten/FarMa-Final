
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
    apiKey: 'AIzaSyBEvH7WUtVOt093Aw5JhZRLywwPSBauB2g',
    appId: '1:401475560603:web:52f6d689ac6d8ff1ca923e',
    messagingSenderId: '401475560603',
    projectId: 'farma-app-84d27',
    authDomain: 'farma-app-84d27.firebaseapp.com',
    storageBucket: 'farma-app-84d27.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5HeTAS1WzVL1OxhXzftCizvTl1Rvxrqs',
    appId: '1:401475560603:android:18745788383b12b0ca923e',
    messagingSenderId: '401475560603',
    projectId: 'farma-app-84d27',
    storageBucket: 'farma-app-84d27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCk9fV9pQbuV4MCZfvQGOkw_s7MCu2O8ZQ',
    appId: '1:401475560603:ios:dbfeb12b1b3b6104ca923e',
    messagingSenderId: '401475560603',
    projectId: 'farma-app-84d27',
    storageBucket: 'farma-app-84d27.appspot.com',
    iosBundleId: 'com.example.agricplant.agriplant',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCk9fV9pQbuV4MCZfvQGOkw_s7MCu2O8ZQ',
    appId: '1:401475560603:ios:a2499d95203fd14eca923e',
    messagingSenderId: '401475560603',
    projectId: 'farma-app-84d27',
    storageBucket: 'farma-app-84d27.appspot.com',
    iosBundleId: 'com.example.agricplant.agriplant.RunnerTests',
  );
}
