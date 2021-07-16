import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});

  final double amount;
  final DateTime dateTime;
  final String id;
  final List<CartItem> products;
}

class Orders with ChangeNotifier {
  var authToken;
  var userId;

  set userIdd(id) {
    this.userId = id;
    notifyListeners();
  }

  List<OrderItem> _orders = [];

  set auth(token) {
    this.authToken = token;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-shop-app-6a672-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');

    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    if (authToken != null) {
      final url = Uri.parse(
          'https://flutter-shop-app-6a672-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken');
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      extractedData[userId].forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }
}
