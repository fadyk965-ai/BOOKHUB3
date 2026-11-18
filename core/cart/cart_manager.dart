import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String author;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartManager extends ChangeNotifier {
  CartManager._();

  static final CartManager instance = CartManager._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold<double>(0, (sum, item) => sum + item.total);

  double get shipping => _items.isEmpty ? 0 : 12.0;

  double get total => subtotal + shipping;

  void addBook({
    required String id,
    required String name,
    required String author,
    required double price,
  }) {
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: id,
          name: name,
          author: author,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    _items[index].quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCard() {
    _items.clear();
    notifyListeners();
  }

  void clearCart() => clearCard();

  void clear() => clearCard();
}
