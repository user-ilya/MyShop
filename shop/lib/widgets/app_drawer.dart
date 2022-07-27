import 'package:flutter/material.dart';
import 'package:shop/pages/UserProductsScreen.dart';

import '../pages/OrdersPage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Меню'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Магазин'),
            onTap: () =>  {
              Navigator.of(context).pushReplacementNamed('/')
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Корзина'),
            onTap: () =>  {
              Navigator.of(context).pushReplacementNamed(OrdersPage.routeName)
            },
          ),
           ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Мои продукты'),
            onTap: () =>  {
              Navigator.of(context).pushReplacementNamed(UserProductsPage.routeName)
            },
          )
        ],
      ),
    );
  }
}