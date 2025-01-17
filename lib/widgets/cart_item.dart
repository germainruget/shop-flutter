import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.price, this.quantity, this.title, this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure ?'),
                  content: Text('Do you want to remove the item from the cart ?'),
                  actions: <Widget>[
                    FlatButton(child: Text('No'), onPressed: () => Navigator.of(ctx).pop(false)),
                    FlatButton(child: Text('Yes'), onPressed: () => Navigator.of(ctx).pop(true)),
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FittedBox(
                  child: Text('$price€'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${price * quantity}€'),
            trailing: Text('$quantity'),
          ),
        ),
      ),
    );
  }
}
