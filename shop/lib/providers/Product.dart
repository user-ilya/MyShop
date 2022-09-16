import 'dart:convert' as json;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({required this.id, required this.title, required this.description, required this.price, required this.imageUrl, this.isFavorite = false});

  void _setValueFavorite (bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String authToken, String userId) async {
    dynamic oldStatus = isFavorite;
    final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/user/$userId/$id.json?auth=$authToken');
      isFavorite = !isFavorite;
      notifyListeners();
    try {
      final response = await http.put(url, body: json.jsonEncode(
        isFavorite
      ));
      if (response.statusCode >= 400) {
        _setValueFavorite(oldStatus);
      }
    } catch (error) {
      _setValueFavorite(oldStatus);
      print(error);
    }

  }
}