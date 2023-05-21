import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:online_shop/constants/color.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final double price;
  final int quantity;

  const CartListItem({
    Key? key,
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    void showDeleteWarning(String id) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
                'This product is being removed from the Shopping cart.'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColor.bgColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  cart.removeAtAll(id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Product Deleted',
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
                },
              ),
            ],
          );
        },
      );
    }

    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          CupertinoButton(
            pressedOpacity: 0.1,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.height * 0.03,
            ),
            onPressed: () {
              showDeleteWarning(id);
            },
            color: CupertinoColors.destructiveRed,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FontAwesomeIcons.solidTrashCan,
                    color: CupertinoColors.white),
                SizedBox(width: 3),
                Text(
                  'Delete',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
          title: Text(title),
          subtitle: Text('All: ${(price * quantity).toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  cart.remove(id);
                },
                icon: const Icon(Icons.remove, color: Colors.black),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Text('$quantity'),
              ),
              IconButton(
                onPressed: () {
                  cart.addToCard(id, title, image, price);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
