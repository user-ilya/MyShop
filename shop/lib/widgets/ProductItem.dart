import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/ProductDetailPage.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem(this.id, this.title, this.imageUrl,{ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/productDetailPage', arguments: product.id);
          },
          child: Image.network(
             product.imageUrl, fit: 
            BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
            onPressed: () async {
              try {
                await product.toggleFavorite(authData.token as String, authData.userId as String);
              } catch (error) {
                scaffold.showSnackBar(SnackBar(content: Text('Запрос не выполнен', textAlign: TextAlign.center,)));
                print(error);
              }
            },
            icon: product.isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
            color: Theme.of(context).accentColor,
          ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} добавлен(а) в корзину'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Отмена',
                    onPressed: () => cart.removeItemSnackbar(product.id),
                  ),
                )
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}