import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/AuthPage.dart';
import 'package:shop/pages/CartPage.dart';
import 'package:shop/pages/EditProductPage.dart';
import 'package:shop/pages/OrdersPage.dart';
import 'package:shop/pages/UserProductsScreen.dart';
import 'package:shop/providers/orders.dart';

import 'providers/Cart.dart';
import './pages/ProductDetailPage.dart';
import './providers/ProductsProvider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key ? key
  }): super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (ctx) => Cart(),),
      ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
      ChangeNotifierProvider(create: (ctx) => Order())
    ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        title: 'Магазин товаров',
        home: AuthPage(),
        routes: {
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrdersPage.routeName: (ctx) => OrdersPage(),
          UserProductsPage.routeName: (ctx) => UserProductsPage(),
          EditProductPage.routeName: (ctx) => EditProductPage()
        },
      ),
    );
  }
}