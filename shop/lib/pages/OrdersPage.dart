import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/AppDrawer.dart';

import '../providers/orders.dart' show Order;
import '../widgets/OrderItem.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({ Key? key }) : super(key: key);

  static const routeName = '/orders';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
      isLoading = true;
    Provider.of<Order>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        isLoading = false;
      });
    } );
  }


  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      drawer: const AppDrawer(),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: orderData.getOrders.length,
        itemBuilder: (context, index) => OrderItem(orderData.getOrders[index])
        )
      );
  }
}