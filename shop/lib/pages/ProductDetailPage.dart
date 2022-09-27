import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ProductsProvider.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/productDetailPage';

  @override
  Widget build(BuildContext context) {
    final selectId = ModalRoute.of(context)?.settings.arguments as String;
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    final productId = productsData.findIdProduct(selectId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productId.title),
              background: Hero(
                tag: productId,
                child: Image.network(productId.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate:  SliverChildListDelegate([
              const SizedBox(height: 10),
              Text(
                'Цена: ${productId.price.toInt()} руб', 
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding:const  EdgeInsets.all(8),
                width: double.infinity,
                child: Text(productId.description, textAlign: TextAlign.center, softWrap: true),
              ),
              SizedBox(height: 800,)
            ]),
          )
        ],
      )
    );
  }
}