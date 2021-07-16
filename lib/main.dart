import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) {
              return Orders();
            },
            update: (ctx, auth, previousOrders) {
              previousOrders.auth = auth.token;
              previousOrders.userId = auth.userId;
              return previousOrders;
            },
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //setter approach
            create: (ctx) => Products(),
            update: (ctx, auth, previousProducts) {
              previousProducts.auth = auth.token;
              previousProducts.userIdd = auth.userId;
              return previousProducts;
            },
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) {
            ifAuth(targetScreen) => auth.isAuth ? targetScreen : AuthScreen();
            return MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? ProductsOverViewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routeName: (ctx) =>
                    ifAuth(ProductDetailScreen()),
                CartScreen.routeName: (ctx) => ifAuth(CartScreen()),
                OrdersScreen.routeName: (ctx) => ifAuth(OrdersScreen()),
                UserProductsScreen.routeName: (ctx) =>
                    ifAuth(UserProductsScreen()),
                EditProductScreen.routeName: (ctx) =>
                    ifAuth(EditProductScreen()),
                AuthScreen.routeName: (ctx) => ifAuth(AuthScreen()),
                ProductsOverViewScreen.routeName: (ctx) =>
                    ifAuth(ProductsOverViewScreen()),
              },
            );
          },
        ));
  }
}
