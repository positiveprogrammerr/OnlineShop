import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/constants/color.dart';
import 'package:online_shop/models/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavourite;

  const ProductsGrid({
    required this.showOnlyFavourite,
    super.key,
  });

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future _productFuture;

  Future _getOrdersFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductfromFirebase();
  }

  @override
  void initState() {
    _productFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child:  CircularProgressIndicator(backgroundColor: AppColor.bgColor,));
        } else if (snapshot.error == null) {
          return Consumer<Products>(builder: (context, productData, child) {
            final products = widget.showOnlyFavourite
                ? productData.favourites
                : productData.products;
            String productName = widget.showOnlyFavourite?'Favourite':'New'; 
            return products.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ChangeNotifierProvider<Product>.value(
                        value: product,
                        child: const ProductItem(),
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text(
                          'Add $productName product',
                          style:const TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        const Icon(
                          CupertinoIcons.bag_fill_badge_plus,
                          size: 33,
                        ),
                      ],
                    ),
                  );
          });
        } else {
          return const Center(
            child: Text('There is an Error'),
          );
        }
      },
    );
  }
}
