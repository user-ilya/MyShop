import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/exceptions.dart';
import 'package:shop/pages/EditProductPage.dart';
import 'package:shop/providers/ProductsProvider.dart';


class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(title),
        trailing:  SizedBox(
          width: 100,
          child: Row(children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName, arguments: id);
            },),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false).removeProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(content: Text('Удаление прервано', textAlign: TextAlign.center,)));
                }
              }, 
              icon: const Icon(Icons.delete), color: Theme.of(context).errorColor,)
          ],),
        ),
      ),
    );
  }
}