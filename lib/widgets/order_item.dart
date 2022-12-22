import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mening_dokonim/models/cart_item.dart';
import '../models/order.dart';

class OrderItem extends StatefulWidget {
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;
  const OrderItem(
      {Key? key,
      required this.totalPrice,
      required this.date,
      required this.products})
      : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.totalPrice}"),
            subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(widget.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandItem = !_expandItem;
                });
              },
              icon: Icon(_expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expandItem)
            Container(
              padding: const EdgeInsets.all(5),
              height: min(widget.products.length * 20 + 50, 100),
              child: ListView.builder(
                  itemCount: widget.products.length,
                  itemExtent: 40,
                  itemBuilder: (ctx, i) {
                    final product = widget.products[i];
                    return ListTile(
                      title: Text(product.title),
                      trailing: Text(
                        '${product.quantity}x \$${product.price}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
