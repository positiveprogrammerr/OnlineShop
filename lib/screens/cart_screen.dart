import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import '../constants/color.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        backgroundColor: const Color(0xFFd1ecfa),
      appBar: AppBar(
        backgroundColor: AppColor.bgColor,
        centerTitle: true,
        title: const Text('Shopping Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16, right: 18),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All :',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      backgroundColor: AppColor.bgColor,
                    ),
                    ProgressOrderButton(cart: cart),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
                    itemCount: cart.items.values.length,
                    itemBuilder: (ctx, index) {
                      final cartItem = cart.items.values.toList()[index];
                      return CartListItem(
                          id: cart.items.keys.toList()[index],
                          image: cartItem.image,
                          title: cartItem.title,
                          price: cartItem.price,
                          quantity: cartItem.quantity);
                    }))
          ],
        ),
      ),
    );
  }
}

class ProgressOrderButton extends StatefulWidget {
  const ProgressOrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<ProgressOrderButton> createState() => _ProgressOrderButtonState();
}

class _ProgressOrderButtonState extends State<ProgressOrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cart.items.isEmpty||_isLoading?null:() async {
          setState(() {
            _isLoading = true;
          });

          // Create a list of Future objects
          final ordersFutures = widget.cart.items.entries.map((entry) {
            final product = entry.value;
            return Provider.of<Orders>(context, listen: false).addToOrders(
              widget.cart.items.values.toList(),
              widget.cart.totalPrice,
              product.image,
              product.title,
            );
          }).toList();

          // Wait for all the Future objects to complete using Future.wait
          await Future.wait(ordersFutures);

          setState(() {
            _isLoading = false;
          });

          widget.cart.clearCart();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed(OrdersScreen.route);
        },
        child: _isLoading
            ? Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(3),
              child: const CircularProgressIndicator(strokeWidth: 3,color: AppColor.bgColor,))
            : Text(
                'Order now',
                style: TextStyle(
                    color: AppColor.bgColor,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ));
  }
}
