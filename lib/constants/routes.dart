import 'package:flutter/material.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/screens/edit_product_screen.dart';
import 'package:online_shop/screens/home_screen.dart';
import 'package:online_shop/screens/manage_products_screen.dart';
import 'package:online_shop/screens/orders_screen.dart';
import '../firebase authentication/sign_in_screen.dart';
import '../screens/product_details_screen.dart';


final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  OrdersScreen.route: (context) => const OrdersScreen(),
  EditProductScreen.routeName: (context) => const EditProductScreen(''),
  ManageProductsScreen.routeName: (context) => const ManageProductsScreen(),
  // SignInScreen.routeName: (context) =>  SignInScreen(),
  SignUpScreen.routeName: (context) =>  const SignUpScreen(),
};
