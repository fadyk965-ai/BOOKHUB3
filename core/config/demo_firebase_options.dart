import 'package:firebase_core/firebase_core.dart';

/// إعداد معرف محلي غير حقيقي يسمح لواجهات Firebase بالتهيؤ دون أسرار أو مشروع فعلي.
/// لا تتصل هذه القيم بمشروع إنتاج ولا تصلح لتسجيل المستخدمين أو تخزين البيانات.
abstract final class DemoFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'demo-only-not-a-secret',
    appId: '1:000000000000:android:bookhub-demo',
    messagingSenderId: '000000000000',
    projectId: 'bookhub-demo-local',
    storageBucket: 'bookhub-demo-local.appspot.com',
  );
}
