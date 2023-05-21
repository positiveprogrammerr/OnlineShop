import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: '1',
      title: 'aden',
      description: 'nejkewf',
      price: 2.32,
      imgUrl:
          'https://thumbs.dreamstime.com/b/boy-camcorder-24469890.jpg',
    ),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favourites {
    return _products.where((element) => element.isFavourite == true).toList();
  }

  Future<void> getProductfromFirebase() async {
    final url = Uri.parse(
        'https://online-shop-d21f7-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      final decodedBody = jsonDecode(response.body);
      if (decodedBody != null) {
        final data = decodedBody as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          if (productData is Map<String, dynamic>) {
            final title = productData['title'] as String?;
            final description = productData['description'] as String?;
            final price = productData['price'] as double?;
            final imgUrl = productData['imageUrl'] as String?;

            if (title != null &&
                description != null &&
                price != null &&
                imgUrl != null) {
              loadedProducts.add(
                Product(
                  id: productId,
                  title: title,
                  description: description,
                  price: price,
                  imgUrl: imgUrl,
                  isFavourite: productData['isFavourite'] ?? false,
                ),
              );
            }
          }
        });
        _products = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url = Uri.parse(
          'https://online-shop-d21f7-default-rtdb.firebaseio.com/products.json');
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imgUrl,
          'isFavourite': product.isFavourite,
        }),
      );
      final responseData = jsonDecode(response.body);
      final newProduct = Product(
        id: responseData['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
      );
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product updateProduct) async {
    final productIndex =
        _products.indexWhere((product) => product.id == updateProduct.id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://online-shop-d21f7-default-rtdb.firebaseio.com/products/${updateProduct.id}.json');
      try {
        await http.patch(
          url,
          body: jsonEncode({
            'title': updateProduct.title,
            'description': updateProduct.description,
            'price': updateProduct.price,
            'imageUrl': updateProduct.imgUrl,
          }),
        );
        _products[productIndex] = updateProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://online-shop-d21f7-default-rtdb.firebaseio.com/products/$id.json');
    try {
      var deletingProduct =
          _products.firstWhere((element) => element.id == id);
      final response = await http.delete(url);
      _products.removeWhere((element) => element.id == id);
      if (response.statusCode >= 400) {
        _products.insert(0, deletingProduct);
        notifyListeners();
        throw const HttpException('There is an error!!');
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _products.firstWhere((pro) => pro.id == productId);
  }
}
