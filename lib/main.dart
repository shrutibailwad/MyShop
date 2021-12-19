import 'package:flutter/material.dart';
import 'package:my_shop/screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/auth.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>Auth()),
      ChangeNotifierProxyProvider<Auth,Products>(update:(ctx,auth,previousProducts)=>Products
        (auth.token, auth.userId,previousProducts==null?[]:previousProducts.items)),
      ChangeNotifierProvider(create: (context)=>Cart()),
      ChangeNotifierProxyProvider<Auth,Orders>(update: (ctx,auth,previousOrders)=>Orders(auth.token,auth.userId,previousOrders==null?[]:previousOrders.items)),
    ],
      child:Consumer<Auth>(builder: (context,auth,_)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'

        ),
        home: auth.isAuth?ProductOverviewScreen():FutureBuilder(future:auth.tryAutoLogin(),builder: (ctx,snapshot)=>snapshot.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen()),
        routes: {
          ProductDetailScreen.routeName:(context)=>ProductDetailScreen(),
          CartScreen.routeName:(context)=>CartScreen(),
          OrderScreen.routeName:(context)=>OrderScreen(),
          UserProductScreen.routeName:(context)=>UserProductScreen(),
          EditProductScreen.routeName:(context)=>EditProductScreen(),
        },
      ),
      )
    );
  }
}


