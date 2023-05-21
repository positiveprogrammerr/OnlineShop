import 'package:flutter/material.dart';
import 'package:online_shop/firebase%20authentication/sign_in_screen.dart';

import '../firebase authentication/auth.dart';
import '../main.dart';
import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  static const TextStyle _listTitleTextStyle =
      TextStyle(fontWeight: FontWeight.w800);
  static const TextStyle _headerTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
  );

  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer header with app name.
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(6, 38, 64, 1),
            ),
            child: Text(
              'Online Shop',
              textAlign: TextAlign.center,
              style: _headerTextStyle,
            ),
          ),

          // Shop button that navigates to the home screen.
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            child: const ListTile(
              leading: Icon(
                Icons.shop,
                color: Colors.black,
              ),
              title: Text(
                'Shop',
                style: _listTitleTextStyle,
              ),
            ),
          ),

          // Orders button that navigates to the orders screen.
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.route);
            },
            child: const ListTile(
              leading: Icon(Icons.assignment, color: Colors.black),
              title: Text(
                'Orders',
                style: _listTitleTextStyle,
              ),
            ),
          ),

          // Manage products button that navigates to the manage products screen.
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ManageProductsScreen.routeName);
            },
            child: const ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text(
                'Manage Products',
                style: _listTitleTextStyle,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Authentication.signOut();
               navigatorKey.currentState!.pushReplacementNamed(SignUpScreen.routeName);
            },
            child: const ListTile(
              leading: Icon(Icons.logout_outlined, color: Colors.black),
              title: Text(
                'Log Out',
                style: _listTitleTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
