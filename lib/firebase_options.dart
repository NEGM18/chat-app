
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
     
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAasLcfozaNF_QNEF3ab0mWvQ5B4PJrszI',
    appId: '1:184972977545:android:4c0a8a36ece59752922d58',
    messagingSenderId: '184972977545',
    projectId: 'chat-d2817',
    storageBucket: 'chat-d2817.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYYDsxVEY8c1bC60VA1uK4iKe7WxzncYQ',
    appId: '1:184972977545:ios:9c3641f29c04a010922d58',
    messagingSenderId: '184972977545',
    projectId: 'chat-d2817',
    storageBucket: 'chat-d2817.appspot.com',
    iosBundleId: 'com.example.chat',
  );
}
