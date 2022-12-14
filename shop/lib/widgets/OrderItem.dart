import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  const OrderItem(this.order,{Key? key }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool _expanded = false; 

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.order.amount} руб'),
            subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: ()  {
                  setState(() {
                    _expanded = !_expanded;
                  });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _expanded ? min(widget.order.products.length*35 + 10, 130) : 0,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: ListView(
              children: widget.order.products.map(
                  (product) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title, 
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '${product.count}x  ${product.price} руб', 
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                        ),)
                    ]
                  )
                ).toList(),
            ),
          )
        ],
      ),
    );
  }
}