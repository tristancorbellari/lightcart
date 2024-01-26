import 'package:flutter/material.dart';
import '../presentation/category_icons.dart';

class ProductIcon extends StatefulWidget {
  final String category;
  final double size;
  final EdgeInsetsGeometry margin;

  const ProductIcon(
      {Key? key,
      required this.category,
      required this.size,
      this.margin = const EdgeInsets.all(8)})
      : super(key: key);

  @override
  State<ProductIcon> createState() => _ProductIcon();
}

class _ProductIcon extends State<ProductIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(width: 2)),
      child: Icon(
        switch (widget.category) {
          "Cheese" => CategoryIcons.cheese,
          "Milk" => CategoryIcons.milk,
          "Meat" => CategoryIcons.meat,
          "Eggs" => CategoryIcons.egg,
          _ => Icons.question_mark,
        },
        color: Colors.pink,
        size: widget.size,
      ),
    );
  }
}
