import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/checkout_request.dart';
import '../../domain/repositories/checkout_repository.dart';

/// تنفيذ Firestore للشراء؛ يعيد قراءة الكتب والأسعار داخل معاملة واحدة قبل الكتابة.
class FirestoreCheckoutRepository implements CheckoutRepository {
  FirestoreCheckoutRepository(this._firestore);

  static const double _deliveryFee = 35;
  final FirebaseFirestore _firestore;

  @override
  Future<String> placeOrder(CheckoutRequest request) async {
    if (request.uid.isEmpty) throw StateError('يجب تسجيل الدخول لإتمام الطلب.');
    final user = _firestore.collection('users').doc(request.uid);
    final order = user.collection('orders').doc();

    // جلب عناصر السلة أولاً قبل الدخول في المعاملة لتجنب مشاكل الـ Query داخل الـ Transaction
    final cartQuerySnapshot = await user.collection('cartItems').get();
    if (cartQuerySnapshot.docs.isEmpty) throw StateError('السلة فارغة.');

    await _firestore.runTransaction((transaction) async {
      var subtotal = 0.0;
      final items = [];

      // تصحيح نوع الـ Map ليتوافق مع DocumentReference بدون تحديد أنواع معقدة قد تسبب تضارب
      final books = <DocumentReference, ({int quantity, Map<String, dynamic> data})>{};

      for (final cart in cartQuerySnapshot.docs) {
      final cartData = cart.data();
      final quantity = (cartData['quantity'] as num?)?.toInt() ?? 0;
      if (quantity < 1) throw StateError('كمية غير صالحة في السلة.');

      final bookRef = _firestore.collection('books').doc(cart.id);
      final book = await transaction.get(bookRef);

      if (!book.exists) throw StateError('أحد الكتب لم يعد متاحاً.');

      final data = book.data();
      if (data == null) throw StateError('بيانات الكتاب غير صالحة.');

      final stock = (data['stock'] as num?)?.toInt() ?? 0;
      final price = (data['price'] as num?)?.toDouble();

      if (price == null || stock < quantity) {
      throw StateError('تغير سعر أو مخزون أحد الكتب. راجع السلة.');
      }

      subtotal += price * quantity;
      books[bookRef] = (quantity: quantity, data: data);

      items.add({
      'bookId': book.id,
      'titleSnapshot': data['title'] as String? ?? '',
      'authorSnapshot': data['author'] as String? ?? '',
      'coverUrlSnapshot': data['coverUrl'] as String? ?? '',
      'unitPrice': price,
      'quantity': quantity,
      });
      }

      final total = subtotal + _deliveryFee;

      // إنشاء الطلب
      transaction.set(order, {
      'items': items,
      'subtotal': subtotal,
      'deliveryFee': _deliveryFee,
      'total': total,
      'address': request.address,
      'phone': request.phone,
      'paymentMethod': 'cash_on_delivery_demo',
      'status': 'placed',
      'createdAt': FieldValue.serverTimestamp(),
      });

      // تحديث المخزون وإضافة الكتب للمكتبة الخاصة بالمستخدم
      for (final entry in books.entries) {
      final data = entry.value.data;
      transaction.update(entry.key, {
      'stock': (data['stock'] as num).toInt() - entry.value.quantity,
      });

      transaction.set(user.collection('library').doc(entry.key.id), {
      'bookId': entry.key.id,
      'titleSnapshot': data['title'] as String? ?? '',
      'authorSnapshot': data['author'] as String? ?? '',
      'coverUrlSnapshot': data['coverUrl'] as String? ?? '',
      'orderId': order.id,
      'purchasedAt': FieldValue.serverTimestamp(),
      });
      }

      // تفريغ السلة بعد إتمام الطلب بنجاح داخل المعاملة
      for (final cart in cartQuerySnapshot.docs) {
      transaction.delete(cart.reference);
      }
    });

    return order.id;
  }
}