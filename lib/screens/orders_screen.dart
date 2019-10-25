import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshData(BuildContext context) async {
      await Provider.of<Orders>(context, listen: false).fetchAnsSetOrders();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAnsSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occured'),
                  );
                }
                else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                          ));
                }
              }
            },
          )),
    );
  }
}
