import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String itemCountText;

  const CustomCart({
    Key? key,
    required this.child,
    required this.itemCountText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        if (itemCountText.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  itemCountText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
