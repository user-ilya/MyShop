import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/ProductsProvider.dart';

import '../pages/CartPage.dart';
import '../providers/Cart.dart';
import '../widgets/Badge.dart';
import '../widgets/app_drawer.dart';
import '../widgets/ProductsGrid.dart';

enum FilterOptions {
  Favorite,
  All
}

class ProductsPage extends StatefulWidget {
   ProductsPage({ Key? key }) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _showFavoriteProducts = false;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () => Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts()).then((_) => setState(() {_isLoading = false;}));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой магазин'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectValue){
              setState(() {
                if (selectValue == FilterOptions.Favorite) {
                  _showFavoriteProducts = true;
              } else {
                _showFavoriteProducts = false;
              } 
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Только избранное'), value: FilterOptions.Favorite,),
              PopupMenuItem(child: Text('Показать всё'), value: FilterOptions.All,)
            ],
            icon: const Icon(Icons.more_vert),  
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch!,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart
                ),
              ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductsGrid(_showFavoriteProducts),
    );
  }
}

