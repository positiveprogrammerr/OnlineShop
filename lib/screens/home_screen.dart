import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/color.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_cart.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FiltersOption {
  favourites,
  all,
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFd1ecfa),
      appBar: AppBar(
        backgroundColor: AppColor.bgColor,
        centerTitle: true,
        title: const Text('Online Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                _showOnlyFavourites = filter == FiltersOption.favourites;
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: FiltersOption.all,
                  child: Text(
                    'All',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                PopupMenuItem(
                  value: FiltersOption.favourites,
                  child: Text(
                    'Favourite',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => CustomCart(
              itemCountText: cart.itemsCount().toString(),
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ProductsGrid(showOnlyFavourite: _showOnlyFavourites),
      drawer: const AppDrawer(),
    );
  }
}
