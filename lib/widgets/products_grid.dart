import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';
import 'items_product.dart';

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
                          child: MasonryGridView.builder(
                              itemCount: ps.length,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) =>
                                  ChangeNotifierProvider<Product>.value(
                                    value: ps[index],
                                    child:const Padding(
                                      padding:  EdgeInsets.all(8),
                                      child: ProductItems(),
                                    ),
                                  ))
                          )
                      : const Center(
                          child: Text('Product not available.'),
                        );
                },
              );
            } else {
              return const Center(
                child: Text("An error occurred"),
              );
            }
          }
        });
  }
}


