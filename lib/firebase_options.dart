// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

//This class configures firebase for various platforms that Flutter can implement with firebase
//Also contains API Keys

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

  static FirebaseOptions createOptions(
      String? apiKey,
      String? appId,
      String? messagingSenderId,
      String? projectId,
      String? authDomain,
      String? databaseURL,
      String? storageBucket,
      String? measurementId) {
    return FirebaseOptions(
      apiKey: apiKey ?? '',
      appId: appId ?? '',
      messagingSenderId: messagingSenderId ?? '',
      projectId: projectId ?? '',
      authDomain: authDomain ?? '',
      databaseURL: databaseURL ?? '',
      storageBucket: storageBucket ?? '',
      measurementId: measurementId ?? '',
    );
  }

  static final FirebaseOptions web = createOptions(
    dotenv.env['webApiKey'],
    dotenv.env['webAppId'],
    dotenv.env['webMessagingSenderId'],
    dotenv.env['webProjectId'],
    dotenv.env['webAuthDomain'],
    dotenv.env['webDatabaseURL'],
    dotenv.env['webStorageBucket'],
    dotenv.env['webMeasurementId'],
  );

  static final FirebaseOptions android = createOptions(
      dotenv.env['androidapiKey'],
      dotenv.env['androidappId'],
      dotenv.env['androidmessagingSenderId'],
      dotenv.env['androidprojectId'],
      dotenv.env['androiddatabaseURL'],
      dotenv.env['androidstorageBucket'],
      null,
      null);

  static final FirebaseOptions ios = createOptions(
    dotenv.env['iosapiKey'],
    dotenv.env['iosappId'],
    dotenv.env['iosmessagingSenderId'],
    dotenv.env['iosprojectId'],
    dotenv.env['iosdatabaseURL'],
    dotenv.env['iosstorageBucket'],
    dotenv.env['iosClientId'],
    dotenv.env['iosBundleId'],
  );

  static final FirebaseOptions macos = createOptions(
    dotenv.env['macapiKey'],
    dotenv.env['macappId'],
    dotenv.env['macmessagingSenderId'],
    dotenv.env['macprojectId'],
    dotenv.env['macdatabaseURL'],
    dotenv.env['macstorageBucket'],
    dotenv.env['maciosClientId'],
    dotenv.env['maciosBundleId'],
  );
}