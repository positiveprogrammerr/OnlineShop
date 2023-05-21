import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

 Future<void> getOrdersfromFirebase() async {
  final url = Uri.parse('https://online-shop-d21f7-default-rtdb.firebaseio.com/orders.json');

  try {
    final response = await http.get(url);
    final decodedBody = jsonDecode(response.body);
    if (decodedBody != null) {
      final data = decodedBody as Map<String, dynamic>;
      List<Order> loadedOrders = [];
      data.forEach((orderId, order) {
        if (order is Map<String, dynamic>) { // Add type check for order
          loadedOrders.insert(
            0,
            Order(
              id: orderId,
              title: order['title'],
              totalPrice: double.parse(order['totalPrice'].toString()), // Convert to double
              date: DateTime.parse(order['date']),
              products: (order['products'] as List<dynamic>)
                  .map((p) => CartItem(
                        id: p['id'],
                        title: p['title'],
                        quantity: p['quantity'],
                        price: p['price'],
                        image: p['image'],
                      ))
                  .toList(),
              image: order['image'],
            ),
          );
        }
      });
      _items = loadedOrders;
    }
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}


  Future<void> addToOrders(List<CartItem> products, double totalPrice, String image, String title) async {
  final url = Uri.parse('https://online-shop-d21f7-default-rtdb.firebaseio.com/orders.json');
    if (title.isEmpty) {
    throw ArgumentError('Title must not be null');
  }
  try {
    final response = await http.post(url,
      body: jsonEncode({
        'title': title,
        'totalPrice': totalPrice,
        'date': DateTime.now().toIso8601String(),
        'products': products.map((CartItem item) {
          return {
            'id': item.id,
            'title': item.title,
            'quantity': item.quantity,
            'price': item.price,
            'image': item.image,
          };
        }).toList(),
        'image': image,
      }),
    );
    final responseData = jsonDecode(response.body);
    _items.insert(
      0,
      Order(
        id: responseData['name'],
        title: title,
        totalPrice: totalPrice,
        date: DateTime.now(),
        products: products,
        image: image,
      ),
    );
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}
}