import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:mening_dokonim/screen/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailesScreen extends StatelessWidget {
  const ProductDetailesScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = "/products-detailes";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final products = Provider.of<Products>(context, listen: false)
        .finById(productId as String);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(products.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                products.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(products.description),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
          child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Narxi: ",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  "\$${products.price}",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) {
                final isProductAdded = cart.items.containsKey(productId);
                if (isProductAdded) {
                  return ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Savatchaga Borish",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      primary: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () => cart.addToCart(productId, products.title,
                        products.imageUrl, products.price),
                    child: const Text("Savatchaga qo'shish"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
