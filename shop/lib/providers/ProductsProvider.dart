import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/exceptions.dart';
import 'dart:convert' as json;

import 'Product.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider(this.authToken,  this._items, this.userId);
  final String? authToken;
  final String? userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Красная рубашка',
    //   description: 'Красная рубашка - это яркая рубашка',
    //   price: 1799,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Брюки',
    //   description: 'Отличная пара брюк',
    //   price: 4199,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Желтый шарф',
    //   description: 'Тепло и уютно - именно то, что нужно этой зимой',
    //   price: 2199,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Кастрюля',
    //   description: 'Приготовьте любую еду, как захотите',
    //   price: 3699,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items => [..._items]; 

  List<Product> get favoriteProducts {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findIdProduct(String idProduct) {
    return _items.firstWhere((element) => element.id == idProduct);
  }

  Future<void> fetchAndSetProducts([bool filter = false ]) async {
    final filterString = filter ? 'orderBy="creatorId"&equalTo="$userId"' :'';
    var url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final bodyAnswer = json.jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product>loadedList = [];
      if (bodyAnswer == null) {
        return;
      }
      url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/user/$userId.json?auth=$authToken');
      final responseFavorite =await http.get(url);
      final favoriteData = json.jsonDecode(responseFavorite.body);
      bodyAnswer.forEach((key, value) {
        loadedList.add(Product(
          id: key, 
          title: value['title'], 
          description: value['description'], 
          price: value['price'], 
          imageUrl: value['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
        ));
      });
      _items = loadedList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct (Product product) {
    final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    return http.post(url, body: json.jsonEncode({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
      'creatorId': userId
      }),
    ).then((response) {
      final newProduct = Product(
        id: json.jsonDecode(response.body)['name'], 
        title: product.title, 
        description: product.description, 
        price: product.price, 
        imageUrl: product.imageUrl
      );
    _items.add(newProduct);
    notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });  
      
  }

  Future<void> updateProduct (String productId, Product newProduct) async {
    var productIdx = _items.indexWhere((element) => element.id == productId);
    
    if (productIdx != null) {
      final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
      try {
        await http.patch(url, 
          body: json.jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }), 
        );
      } catch (error) {
          print(error);
          throw error;
      }
      _items[productIdx] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeProduct(String productId) async {
      final url = Uri.parse('https://flutter-app-1c25c-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
      final existingProductIndex = _items.indexWhere((element) => element.id == productId);
      dynamic existingProduct = _items[existingProductIndex];

      _items.removeAt(existingProductIndex);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw const HttpException('Невозможно удалить продукт, повторите позже');
      }
      existingProduct = null;
  }
}