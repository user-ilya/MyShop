import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ProductsProvider.dart';
import 'ProductItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavoriteProducts;
   ProductsGrid(this.isFavoriteProducts, {
    Key? key,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts = isFavoriteProducts ? productsData.favoriteProducts : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10, // количество столбцов
      ), 
      itemBuilder: (ctx, index) => 
        ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: ProductItem(),
        ),
    );
  }
}