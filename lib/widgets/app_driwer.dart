import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/screen/home_screen.dart';
import 'package:mening_dokonim/screen/manager_product_screen.dart';
import 'package:mening_dokonim/screen/orders_screen.dart';
import 'package:provider/provider.dart';

class AppDriwer extends StatelessWidget {
  const AppDriwer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text("Salom Do'stim"),
          ),
          ListTile(
              leading: const Icon(Icons.shop),
              title: const Text("Magazin"),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                    HomeScreen.routeName,
                  )),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Byurtmalar"),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                    OrdersScreen.routeName,
                  )),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Maxsulotlarni boshqarish"),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                    ManagerProductScreen.routeName,
                  )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Chiqish"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
