import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/constants/color.dart';
import 'package:online_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const route = '/orders';

  const OrdersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isExpanded = false;
  // var _isLoading = false;
  late Future _ordersFuture;
  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersfromFirebase();
  }

  @override
  void initState() {
    _ordersFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFd1ecfa),
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: AppColor.bgColor,
          centerTitle: true,
          title: const Text('Orders'),
        ),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: AppColor.bgColor,
                ));
              } else if (dataSnapshot.error == null) {
                return Consumer<Orders>(
                  builder: (context, orders, child) {
                    return orders.items.isEmpty
                        ? const Center(
                            child: Text(
                              'There is no orders',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: orders.items.length,
                            itemBuilder: (ctx, index) {
                              final order = orders.items[index];

                              double totalPrice = 0;
                              for (var product in order.products) {
                                totalPrice += product.price * product.quantity;
                              }

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 36,
                                        backgroundImage:
                                            NetworkImage(order.image),
                                      ),
                                      title: Text(
                                        order.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        DateFormat('MM/dd/yyyy hh:mm a')
                                            .format(order.date),
                                      ),
                                    ),
                                    ExpansionTile(
                                      title: const Text(''),
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      initiallyExpanded: _isExpanded,
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          _isExpanded = value;
                                        });
                                      },
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                      leading: const Icon(
                                        FontAwesomeIcons.cartShopping,
                                        size: 20,
                                        color: AppColor.bgColor,
                                      ),
                                      trailing: Icon(
                                        _isExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: AppColor.bgColor,
                                      ),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: order.products.length,
                                          itemBuilder: (ctx, i) {
                                            final product = order.products[i];
                                            final productPrice = product.price *
                                                product.quantity;
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  product.title,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${productPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87),
                                                ),
                                                Text(
                                                  '\$${product.price.toStringAsFixed(0)} x ${product.quantity}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '\$${totalPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  },
                );
              } else {
                return const Center(
                  child: Text('There is an Error'),
                );
              }
            }));
  }
}
