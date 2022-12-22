import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;

  const CustomCart({Key? key, required this.child, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            top: 15,
            right: 10,
            child: Container(
              alignment: Alignment.center,
              width: 11,
              height: 11,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
