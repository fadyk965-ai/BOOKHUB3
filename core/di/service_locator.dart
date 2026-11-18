/// نقطة وصول مركزية للخدمات، تمنع إنشاء Firebase داخل Widgets.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/checkout/data/repositories/firestore_checkout_repository.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/place_order.dart';

/// حاوية خفيفة مؤقتة للتشغيل قبل تثبيت أدوات توليد DI.
class ServiceRegistry {
  late final FirebaseAuth auth = FirebaseAuth.instance;
  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CheckoutRepository checkoutRepository = FirestoreCheckoutRepository(firestore);
  late final PlaceOrder placeOrder = PlaceOrder(checkoutRepository);
}

/// النسخة المشتركة المستخدمة من طبقة العرض عبر use cases فقط.
final ServiceRegistry services = ServiceRegistry();

/// واجهة تهيئة موحدة يمكن استبدالها لاحقاً بتسجيل get_it/injectable.
Future<void> configureDependencies() async {}
