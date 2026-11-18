import '../entities/checkout_request.dart';
import '../repositories/checkout_repository.dart';

/// حالة استخدام تنسق عملية الطلب وتُبقي واجهة المستخدم خالية من منطق الأعمال.
class PlaceOrder {
  const PlaceOrder(this._repository);

  final CheckoutRepository _repository;

  /// ينفذ المعاملة ويعيد رقم الطلب المؤكد فقط بعد نجاح الكتابة الذرية.
  Future<String> call(CheckoutRequest request) => _repository.placeOrder(request);
}
