import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './orders_screen.dart';

import '../widgets/cart_item.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('${cart.totalAmount.toStringAsFixed(2)}€'),
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.item.values.toList()[i].id,
                price: cart.item.values.toList()[i].price,
                quantity: cart.item.values.toList()[i].quantity,
                title: cart.item.values.toList()[i].title,
                productId: cart.item.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      child: _isLoading ? CircularProgressIndicator() : Text('Order now ! '),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
               _isLoading = true; 
              });
              await Provider.of<Orders>(context, listen: false)
                  .addOrder(
                widget.cart.item.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
               _isLoading = false; 
              });
              widget.cart.clear();
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
    );
  }
}
