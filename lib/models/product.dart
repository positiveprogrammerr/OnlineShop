// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl; 
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite() async{
    var oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

     final url = Uri.parse(
          'https://online-shop-d21f7-default-rtdb.firebaseio.com/products/$id.json');

    try {
    final response = await http.patch(url,body: jsonEncode(
        {
          'isFavourite':isFavourite,
        }
      ));
      if(response.statusCode>=400){
        isFavourite = oldFavourite;
        notifyListeners();
      }
    } catch (e) {
       isFavourite = oldFavourite;
        notifyListeners();
    }
  }
  
}
