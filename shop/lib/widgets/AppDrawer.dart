import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helper/custom_route.dart';
import 'package:shop/pages/UserProductsScreen.dart';

import '../pages/OrdersPage.dart';
import '../providers/auth.dart';

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
              //Navigator.of(context).pushReplacementNamed(OrdersPage.routeName)
              Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrdersPage()))
            },
          ),
           ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Мои продукты'),
            onTap: () =>  {
              Navigator.of(context).pushReplacementNamed(UserProductsPage.routeName)
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Выйти'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}