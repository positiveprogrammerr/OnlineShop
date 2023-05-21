import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/providers/cart.dart';
import 'package:online_shop/providers/products.dart';
import 'package:online_shop/screens/cart_screen.dart';
import '../constants/color.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
        backgroundColor: const Color(0xFFd1ecfa),
        appBar: AppBar(
          title: Text(product.title),
          backgroundColor: AppColor.bgColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: productId,
                  child: Image.network(
                    product.imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 100,
            color: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Consumer<Cart>(builder: (_, cart, __) {
                  return Row(
                    children: [
                      cart.items.containsKey(productId)
                          ? ElevatedButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(CartScreen.routeName),
                              icon: const Icon(
                                Icons.shopping_bag,
                                size: 20,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Go to Cart',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                minimumSize: const Size(200, 50),
                                backgroundColor: Colors.grey.shade200,
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => cart.addToCard(
                                productId,
                                product.title,
                                product.imgUrl,
                                product.price,
                              ),
                              icon: const Icon(
                                Icons.shopping_bag,
                                size: 20,
                              ),
                              label: const Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                minimumSize: const Size(200, 50),
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                      const SizedBox(
                        width: 80,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:15.0),
                        child: Column(
                          children: [
                           const  Text("Price:",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),),
                      
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }))));
  }
}
