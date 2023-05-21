import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemsCount(){
    return _items.length;
  }

  double get totalPrice{
    var total = 0.0;
    _items.forEach((key, value) {
       total+=value.price*value.quantity;
    });
    return total;
  }

  void addToCard(String productId, String title, String image, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (currentProduct) => CartItem(
              id: currentProduct.id,
              title: currentProduct.title,
              quantity: currentProduct.quantity + 1,
              price: currentProduct.price,
              image: currentProduct.image));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: UniqueKey().toString(),
              title: title,
              quantity: 1,
              price: price,
              image: image));
    }
    notifyListeners();
  }

 removeAtAll(String id){
   _items.remove(id);
   notifyListeners();
}

 void remove(String id) {
  if (!_items.containsKey(id)) {
    return;
  }

  final currentItem = _items[id];

  if (currentItem!.quantity > 1) {
    _items.update(
      id,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        quantity: existingCartItem.quantity - 1,
        price: existingCartItem.price,
        image: existingCartItem.image,
      ),
    );
  } 
  notifyListeners();
}

void clearCart(){
  _items.clear();
  notifyListeners();
}

  void decrementQuantity(String id) {}

}
