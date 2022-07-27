import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String productId;
  final String title;
  final int count;
  final int price;

  CartItem(this.id, this.productId, this.title, this.price, this.count,{ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context, 
          builder: (ctx) => AlertDialog(
            title: const Text('Удаление'),
            content: const Text('Вы действительно хотите удалить этот товар ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                }, 
                child: const Text('Да')
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                }, 
                child: const Text('Нет'),
              )
            ],
          )
        );
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(Icons.delete, color: Colors.white, size: 28,),
        alignment: Alignment.centerRight, 
        padding: const EdgeInsets.only(right: 20), 
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text('$price руб', style: const TextStyle(fontSize: 14, color: Colors.white),),
            ),
              ) ),
            title: Text(title),
            subtitle: Text('${price * count} руб'),
            trailing: Text('$count x'),
          ),
        ),
      ),
    );
  }
}