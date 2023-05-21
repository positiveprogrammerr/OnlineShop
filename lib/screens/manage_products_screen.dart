import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  static const routeName = '/manage';

  Future<void> _refreshProducts(BuildContext context) async{
   await Provider.of<Products>(context,listen: false).getProductfromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return Scaffold(
        backgroundColor: const Color(0xFFd1ecfa),
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
           Navigator.pushNamed(context,EditProductScreen.routeName);
          }, icon: const Icon(Icons.add)),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 38, 65),
        title: const Text('Manage Products'),
      ),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ChangeNotifierProvider.value(
                value: product, child: const UserProductItem());
          },
        ),
      ),
    );
  }
}
