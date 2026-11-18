/// هذا الملف يستبدله FlutterFire CLI ببيانات مشروع Firebase الحقيقي؛ لا تضع مفاتيح خدمة إدارية هنا.
library;

import 'package:firebase_core/firebase_core.dart';

/// يمنع التشغيل ببيانات وهمية ويجعل نقص إعداد Firebase ظاهراً وقابلاً للتشخيص.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'Firebase is not configured. Run: dart pub global activate flutterfire_cli && flutterfire configure',
  );
}
