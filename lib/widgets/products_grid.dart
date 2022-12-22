import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatefulWidget {
  final bool showFavorites;

  const ProductGrid(
    this.showFavorites, {
    Key? key,
  }) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future _productFuture;

  Future _getProductFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductFromFirebase();
  }

  @override
  void initState() {
    _productFuture = _getProductFuture();
    super.initState();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false)
        .getProductFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return FutureBuilder(
        future: _productFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Products>(
                builder: (ctx, products, child) {
                  final ps =
                      widget.showFavorites ? products.favorites : products.list;

                  return ps.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: _refreshProducts,
                          child: GridView.builder(
                              padding: const EdgeInsets.all(20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 3 / 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20),
                              itemCount: ps.length,
                              itemBuilder: (ctx, i) {
                                return ChangeNotifierProvider<Product>.value(
                                  value: ps[i],
                                  child: const ProductItem(),
                                );
                              }),
                        )
                      : const Center(
                          child: Text('Mahsulot mavjud emas.'),
                        );
                },
              );
            } else {
              return const Center(
                child: Text("Xatolik sodir bo'ldi"),
              );
            }
          }
        });
  }
}
