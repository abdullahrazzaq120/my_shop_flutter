import 'package:flutter/material.dart';
import 'package:my_shop_flutter/providers/auth.dart';
import 'package:my_shop_flutter/providers/cart.dart';
import 'package:my_shop_flutter/providers/product.dart';
import 'package:my_shop_flutter/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String? id;
  // final String? title;
  // final String? imageUrl;
  //
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //listening product changing
    Product product = Provider.of<Product>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);
    Cart cart = Provider.of<Cart>(context, listen: false);
    /*It will only print one time due to listen false*/
    print('Rebuild');
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(
            product.title!,
          ),
          /*Consumer<Object> can rebuild the widget which you want to rebuild whether the listen is false in Provider*/
          leading: Consumer<Product>(
            builder: (ctx, p, child) {
              /*child is something which won't be affected even with this consumer(and if the listen is false)*/
              return IconButton(
                icon: Icon(
                    p.isFavourite ? Icons.favorite : Icons.favorite_border),
                color: p.isFavourite ? Colors.redAccent : Colors.white,
                onPressed: () {
                  product.toggleFavouriteStatus(auth.token!, auth.userId!);
                },
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              cart.addItemToCart(product.id!, product.price!, product.title!);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Item Added to Cart!'),
                duration: Duration(
                  seconds: 2,
                ),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeItem(product.id!);
                    }),
              ));
            },
          ),
        ),
      ),
    );
  }
}
