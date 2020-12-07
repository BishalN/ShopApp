import 'package:flutter/material.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './provider/products.dart';
import './provider/cart.dart';
import './screens/cart_screen.dart';
import './provider/order.dart';
import './screens/order_Screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';
import './widgets/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products(),
              update: (ctx, auth, previousProduct) => Products(
                  itemsList: previousProduct.itemsList == null
                      ? []
                      : previousProduct.items,
                  authToken: auth.token,
                  userId: auth.userId)),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(),
            update: (_, auth, previousOrders) => Orders(
                authToken: auth.token,
                userId: auth.userId,
                orderList: previousOrders.orderList == null
                    ? []
                    : previousOrders.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return MaterialApp(
                theme: ThemeData(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato'),
                home: auth.isAuth
                    ? ProductOverviewScreen()
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
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                  UserProductScreen.routeName: (ctx) => UserProductScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                });
          },
        ));
  }
}
