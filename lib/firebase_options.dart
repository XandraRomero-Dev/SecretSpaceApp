import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you are only configured for android.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCD9ntuCtp7mLyt8-mLRI3iqyC_tS-ZaJQ',
    appId: '1:854706494557:android:aeb5896f6ac754de7101b4',
    messagingSenderId: '854706494557',
    projectId: 'secretspaceapp',
    storageBucket: 'secretspaceapp.firebasestorage.app',
  );
}
