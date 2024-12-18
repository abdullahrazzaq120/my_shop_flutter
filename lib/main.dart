import 'package:flutter/material.dart';
import 'package:my_shop_flutter/helpers/custom_route.dart';
import 'package:my_shop_flutter/providers/auth.dart';
import 'package:my_shop_flutter/providers/cart.dart';
import 'package:my_shop_flutter/providers/products.dart';
import 'package:my_shop_flutter/screens/auth_screen.dart';
import 'package:my_shop_flutter/screens/cart_screen.dart';
import 'package:my_shop_flutter/screens/edit_product_screen.dart';
import 'package:my_shop_flutter/screens/orders_screen.dart';
import 'package:my_shop_flutter/screens/product_detail_screen.dart';
import 'package:my_shop_flutter/screens/products_overview_screen.dart';
import 'package:my_shop_flutter/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/orders.dart';
import 'screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // from where data is coming and to where data is going
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId,
          ),
          create: (ctx) => Products('', [], ''),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId,
          ),
          create: (ctx) => Orders('', [], ''),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
