import '../entities/checkout_request.dart';

/// عقد تنفيذ الطلب: طبقة المجال لا تعرف Firestore أو Widgets.
abstract interface class CheckoutRepository {
  Future<String> placeOrder(CheckoutRequest request);
}
