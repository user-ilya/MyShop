import 'dart:convert' as json;

import 'package:flutter/foundation.dart';
import 'package:shop/providers/Cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/Product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amount, required this.products, required this.dateTime});
}

class Order with ChangeNotifier {
  Order(this.authToken, this.userId, this._orders);
  final String? authToken;
  final String? userId;

  late List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders () async {
    final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final extractedData = json.jsonDecode(response.body) as Map<String,dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderValue) {
      loadedOrders.add(OrderItem(
        id: orderId, 
        amount: orderValue['amount'], 
        products: (orderValue['products'] as List<dynamic>).map((item) => CartItem(id: item['id'], count: item['count'], title: item['title'], price: item['price'])).toList(), 
        dateTime: DateTime.parse(orderValue['dateTime'])
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
  
  Future<void> addOrder(List<CartItem> cardProducts, double total) {
    final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken');
    final arr = [];
    for (var i =0; i < cardProducts.length; i++) {
      final product = {
        'id': cardProducts[i].id,
        'count': cardProducts[i].count,
        'price': cardProducts[i].price,
        'title': cardProducts[i].title
      };
      arr.add(product);
    }
      final time = DateTime.now().toIso8601String();
      return http.post(url, body: json.jsonEncode({
        'amount': total,
        'products': cardProducts.map((card) => {
          'id': card.id,
          'title': card.title,
          'count': card.count,
          'price': card.price
        }).toList(),
        'dateTime': time
      }))
      .then((response) {
        final newOrder = OrderItem(
          id: json.jsonDecode(response.body)['name'], 
          amount: total, 
          products: cardProducts, 
          dateTime: DateTime.now()
        );
        _orders.add(newOrder);
        notifyListeners();
      }).catchError((error) {
        print(error);
      });
    
  }

}