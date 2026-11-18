/// قيم طلب الشراء التي لا تتضمن سعراً يثق به الخادم أو العميل.
class CheckoutRequest {
  const CheckoutRequest({
    required this.uid,
    required this.address,
    required this.phone,
  });

  final String uid;
  final String address;
  final String phone;
}
