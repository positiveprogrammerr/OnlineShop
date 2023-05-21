// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:online_shop/models/cart_item.dart';

class Order {
  final String id;
  final String title;
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;
  final String image;
  
  Order({
    required this.id,
    required this.title,
    required this.totalPrice,
    required this.date,
    required this.products,
    required this.image,
  });
  
}
