import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {

  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> _orders = [];

  Future<void> fetchAnsSetOrders() async {
    final url = 'https://shop-app-e004e.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        final List<OrderItem> loadedOrders = [];
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
                id:item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title'],
              )).toList(),
            ),
          );
        });
        _orders = loadedOrders.reversed.toList();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // print(cartProducts);
    final url = 'https://shop-app-e004e.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts.map((product) {
              return {
                'id': product.id,
                'price': product.price,
                'quantity': product.quantity,
                'title': product.title,
              };
            }).toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
