import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:mening_dokonim/screen/edit_product_screen.dart';
import 'package:mening_dokonim/widgets/app_driwer.dart';
import 'package:mening_dokonim/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class ManagerProductScreen extends StatelessWidget {
  const ManagerProductScreen({Key? key}) : super(key: key);

  static const routeName = "/manager-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getProductFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshotData) {
            if (snapshotData.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshotData.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (context, productProvider, child) {
                    return ListView.builder(
                      itemCount: productProvider.list.length,
                      itemBuilder: (ctx, i) {
                        final product = productProvider.list[i];
                        return ChangeNotifierProvider.value(
                          value: product,
                          child: const UserProductItem(),
                        );
                      },
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("An error occurred..."),
              );
            }
          }),
      drawer: const AppDriwer(),
    );
  }
}
