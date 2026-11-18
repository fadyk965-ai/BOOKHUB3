/// حالة التشغيل الحالية؛ تُستخدم لتقديم تجربة محلية آمنة قبل إعداد Firebase الحقيقي.
abstract final class AppMode {
  /// تصبح صحيحة فقط إذا تعذر تحميل إعدادات FlutterFire المولّدة.
  static bool isDemo = false;
}
