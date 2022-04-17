import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};

  Map<String, CartItem> get items {
    return {..._items!};
  }

  int get itemsCount {
    return _items!.length;
  }

  void addItemToCart(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      //change quantity
      _items!.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity! + 1,
        ),
      );
    } else {
      /*putIfAbsent adds new value in map*/
      _items!.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items?.forEach((key, cartItem) {
      total += cartItem.price! * cartItem.quantity!;
    });
    return total;
  }

  void removeItem(String productId) {
    _items?.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
