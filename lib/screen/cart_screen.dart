import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/providers/orders.dart';
import 'package:mening_dokonim/screen/orders_screen.dart';
import 'package:mening_dokonim/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your Shopping Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "General:",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final cartItem = cart.items.values.toList()[i];
                return CartListItem(
                  productId: cart.items.keys.toList()[i],
                  imageUrl: cartItem.image,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false).addToOrders(
                  widget.cart.items.values.toList(), widget.cart.totalPrice);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER"),
    );
  }
}
