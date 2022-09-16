import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/EditProductPage.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/widgets/AppDrawer.dart';

import '../providers/ProductsProvider.dart';
import '../widgets/UserProductItem.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({ Key? key }) : super(key: key);

  static const routeName = '/userProducts';

  Future<void> _refreshProducts (BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои продукты'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            }, 
            icon: const Icon(Icons.add)
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx, snapshot) => 
        snapshot.connectionState == ConnectionState.waiting 
        ?  const Center(child: CircularProgressIndicator(),) 
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductsProvider>(
            builder: (ctx, products, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (_, idx) {
                  return Column(
                    children: [
                      UserProductItem(
                        products.items[idx].id,
                        products.items[idx].title, 
                        products.items[idx].imageUrl,
                      ),
                      const Divider()
                    ],
                  );
                },
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}