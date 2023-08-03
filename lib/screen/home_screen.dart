import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/screen/cart_screen.dart';
import 'package:mening_dokonim/widgets/app_driwer.dart';
import 'package:mening_dokonim/widgets/custom_cart.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';

enum FilterOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Store"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption filter) {
              setState(() {
                if (filter == FilterOption.All) {
                  //...barchasini ko'rsat
                  _showOnlyFavorites = false;
                } else {
                  //...sevimlilarni ko'rsat
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return const [
                PopupMenuItem(
                  child: const Text("Everything"),
                  value: FilterOption.All,
                ),
                PopupMenuItem(
                  child: const Text("Favorites"),
                  value: FilterOption.Favorites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                child: child!,
                number: cart.itemsCount().toString(),
              );
            },
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const AppDriwer(),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
