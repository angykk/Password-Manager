import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      case TargetPlatform.linux:
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['WEB_API_KEY']!,
        appId: dotenv.env['WEB_APP_ID']!,
        messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['WEB_PROJECT_ID']!,
        authDomain: dotenv.env['WEB_AUTH_DOMAIN']!,
        storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
        measurementId: dotenv.env['WEB_MEASUREMENT_ID']!,
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['ANDROID_API_KEY']!,
        appId: dotenv.env['ANDROID_APP_ID']!,
        messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['WEB_PROJECT_ID']!,
        storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.env['IOS_API_KEY']!,
        appId: dotenv.env['IOS_APP_ID']!,
        messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['WEB_PROJECT_ID']!,
        storageBucket: dotenv.env['WEB_STORAGE_BUCKET']!,
        iosBundleId: dotenv.env['IOS_BUNDLE_ID']!,
      );

  static FirebaseOptions get macos => ios;
}
