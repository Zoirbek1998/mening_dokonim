import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screen/product_detailes_screen.dart';

class ProductItems extends StatelessWidget {
  const ProductItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return Consumer<Product>(builder: (ctx, pro, child) {
      return GestureDetector(
       onTap: (){
         Navigator.of(context).pushNamed(ProductDetailesScreen.routeName,
             arguments: product.id);
       },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.teal.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 3)
                  ]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(product.imageUrl)),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: GridTileBar(
                    backgroundColor: Colors.black26,
                    leading: IconButton(
                        onPressed: () {
                          pro.toggleFavirite(auth.token!, auth.userId!);
                        },
                        icon: Icon(
                            pro.isFavorites
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            size: 20,
                            color: Theme.of(context).primaryColor)),
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
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Added to cart!"),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                                label: 'CANCELLATION',
                                onPressed: () {
                                  cart.removeSingelItem(product.id, isCartButton: true);
                                }),
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_bag_outlined,
                          size: 20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ))

            // Positioned(
            //   left: 10,
            //   bottom: 10,
            //   child: Container(
            //     width: 35,
            //     height: 35,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         shape: BoxShape.circle,
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.1),
            //               blurRadius: 3,
            //               spreadRadius: 2)
            //         ]),
            //     child: IconButton(
            //         onPressed: () {
            //           pro.toggleFavirite(auth.token!, auth.userId!);
            //         },
            //         icon: Icon(
            //             pro.isFavorites
            //                 ? Icons.favorite
            //                 : Icons.favorite_border_outlined,
            //             size: 20,
            //             color: Colors.red)),
            //   ),
            // ),
            // Positioned(
            //   right: 10,
            //   bottom: 10,
            //   child: Container(
            //     width: 35,
            //     height: 35,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         shape: BoxShape.circle,
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.1),
            //               blurRadius: 3,
            //               spreadRadius: 2)
            //         ]),
            //     child: IconButton(
            //         onPressed: () {
            //           pro.toggleFavirite(auth.token!, auth.userId!);
            //         },
            //         icon: Icon(
            //           Icons.shopping_cart_outlined,
            //           color: Theme.of(context).primaryColor,
            //           size: 20,
            //         )),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
