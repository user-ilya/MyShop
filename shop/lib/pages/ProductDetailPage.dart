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
      appBar: AppBar(
        title: Text(productId.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(productId.imageUrl, fit: BoxFit.cover,),
            ),
            const SizedBox(height: 10,),
            Text('Цена: ${productId.price.toInt()} руб', style: const TextStyle(
              color: Colors.grey,
              fontSize: 20
            ),),
            const SizedBox(height: 10,),
            Container(
              padding:const  EdgeInsets.all(8),
              width: double.infinity,
              child: Text(productId.description, textAlign: TextAlign.center, softWrap: true,)),
          ],
        ),
      )
    );
  }
}