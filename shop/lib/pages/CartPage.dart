import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';

import '../providers/Cart.dart' show Cart;
import '../widgets/CartItem.dart' as ci;

class CartPage extends StatefulWidget {
  static const routeName = '/cart';

  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var isSending = false;

  @override
  Widget build(BuildContext context) {
     final cart = Provider.of<Cart>(context);
     final orders = Provider.of<Order>(context, listen: false);
     final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваша корзина'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Всего:', style: TextStyle(
                    fontSize: 20,
                  ),),
                  Spacer(),
                  Chip(
                    label: Text('${cart.totalAmount} руб', 
                    style: TextStyle(
                      color: Colors.white
                    ),),
                    
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      if (cart.items.isEmpty | isSending) {
                        scaffold.showSnackBar(SnackBar(content: Text('Заказов нет !')));
                        return;
                      }
                      setState(() {
                        isSending = true;
                      });
                      await orders.addOrder(cart.items.values.toList(), cart.totalAmount).then((_) {
                        setState(() {
                          isSending = false;
                        });
                      });
                      cart.clear();
                    }, 
                    child: isSending ? const Center(child: CircularProgressIndicator()) : Text('Добавить', style: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, i) => ci.CartItem(
              cart.items.values.toList()[i].id, 
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].title, 
              cart.items.values.toList()[i].price.toInt(), 
              cart.items.values.toList()[i].count
            )
            ))

        ],
      ),
    );
  }
}