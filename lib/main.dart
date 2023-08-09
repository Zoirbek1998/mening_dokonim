import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/product_detailes_screen.dart';
import './styles/my_shop_styles.dart';
import './screen/home_screen.dart';
import '../styles/my_shop_styles.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './providers/orders.dart';
import './screen/cart_screen.dart';
import './screen/orders_screen.dart';
import '../providers/auth.dart';
import '../screen/auth_screen.dart';
import '../screen/edit_product_screen.dart';
import '../screen/manager_product_screen.dart';
import '../screen/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  ThemeData theme = MyShopStyles.theme;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (context, auth, previousProducts) =>
              previousProducts!..setParams(auth.token, auth.userId),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (context, auth, previousOrders) =>
              previousOrders!..setParams(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Store',
            theme: theme,
            home: authData.isAuth
                ? const HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (c, autoLoginData) {
                      if (autoLoginData.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
            routes: {
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              ProductDetailesScreen.routeName: (ctx) =>
                  const ProductDetailesScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ManagerProductScreen.routeName: (ctx) =>
                  const ManagerProductScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
