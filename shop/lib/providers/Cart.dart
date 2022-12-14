import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final int count;
  final String title;
  final double price;

  CartItem({required this.id,required this.count, required this.title,required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.isEmpty ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((idx, cartItem) {
      total += cartItem.price * cartItem.count;
    });
    return total;
  }

  void addToCart (String productId, String title, double price) {
    if (_items.containsKey(productId)) {
       _items.update(productId, (existingCartItem) => CartItem(id: existingCartItem.id, count: existingCartItem.count + 1, title: existingCartItem.title, price: existingCartItem.price));
    } else {
      _items.putIfAbsent(productId, () => CartItem(id: productId, count: 1, title: title, price: price));
    }
    notifyListeners();
  }

  void removeItem (String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemSnackbar (String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.count > 1) {
      _items.update(productId, (itemVal) => CartItem(id: itemVal.id, count: itemVal.count - 1, title: itemVal.title, price: itemVal.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }


  void clear () {
    _items = {};
    notifyListeners();
  }
}

