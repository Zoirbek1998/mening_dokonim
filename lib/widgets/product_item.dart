import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mening_dokonim/models/product.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/screen/product_detailes_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailesScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, pro, child) {
              return IconButton(
                onPressed: () {
                  pro.toggleFavirite(auth.token!, auth.userId!);
                },
                icon: Icon(
                  pro.isFavorites
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(
                product.id,
                product.title,
                product.imageUrl,
                product.price,
              );

              // TEPADAN CHIQADIGON TOUST

              // ScaffoldMessenger.of(context).showMaterialBanner(
              //   MaterialBanner(
              //     backgroundColor: Colors.grey.shade600,
              //     content: const Text(
              //       "Savatchaga qo'shildi!",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           cart.removeSingelItem(product.id, isCartButton: true);
              //           ScaffoldMessenger.of(context)
              //               .hideCurrentMaterialBanner();
              //         },
              //         child: const Text("BEKOR QILISH"),
              //       ),
              //     ],
              //   ),
              // );
              // Future.delayed(Duration(seconds: 2)).then((value) =>
              //     ScaffoldMessenger.of(context).hideCurrentMaterialBanner());

              // PASTDAN CHIQADIGON TOUST

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Savatchaga qo'shildi!"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'BEKOR QILISH',
                      onPressed: () {
                        cart.removeSingelItem(product.id, isCartButton: true);
                      }),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
