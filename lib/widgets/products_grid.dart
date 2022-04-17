import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final _isOnlyFavouriteEnable;

  ProductsGrid(this._isOnlyFavouriteEnable);

  @override
  Widget build(BuildContext context) {
    //listening product list changing
    final productsData = Provider.of<Products>(context);
    final products = _isOnlyFavouriteEnable
        ? productsData.favoriteItems
        : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        /*Use .value when no need of context*/
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
      padding: EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
