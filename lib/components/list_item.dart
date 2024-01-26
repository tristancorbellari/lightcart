import 'package:flutter/material.dart';

import 'product_icon.dart';
import '../presentation/custom_route.dart';
import '../screens/product_screen.dart';
import '../util/utils.dart';

class ListItem extends StatefulWidget {
  String productKey;
  String barcode;
  String productName;
  String category;
  String retailer;
  double units;
  String unitOfMeasurement;
  double price;
  VoidCallback sortProducts;

  ListItem({
    Key? key,
    required this.productKey,
    required this.barcode,
    required this.productName,
    required this.category,
    required this.retailer,
    required this.units,
    required this.unitOfMeasurement,
    required this.price,
    required this.sortProducts,
  }) : super(key: key);

  double getCostPerUnitOfMeasurement() {
    return price / units;
  }

  @override
  State<ListItem> createState() => _ListItem();
}

class _ListItem extends State<ListItem> {
  void updateProduct(String productName, String category, String retailer,
      double units, String unitOfMeasurement, double price) {
    setState(() {
      widget.productName = productName;
      widget.category = category;
      widget.retailer = retailer;
      widget.units = units;
      widget.unitOfMeasurement = unitOfMeasurement;
      widget.price = price;

      widget.sortProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      color: const Color.fromARGB(255, 243, 240, 240),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                buildPageWithSlideTransition(
                    context: context,
                    screen: ProductScreen(
                      productKey: widget.productKey,
                      barcode: widget.barcode,
                      productName: widget.productName,
                      category: widget.category,
                      retailer: widget.retailer,
                      units: widget.units,
                      unitOfMeasurement: widget.unitOfMeasurement,
                      price: widget.price,
                      setProduct: updateProduct,
                      setKey: (String) {},
                    )));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProductIcon(category: widget.category, size: 35),
                  RichText(
                    text: TextSpan(
                        text: widget.productName,
                        style: const TextStyle(
                            fontSize: 16, height: 1, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "\n${widget.retailer}\n${doubleFormat(widget.units)} ${widget.unitOfMeasurement}\nR${doubleFormat(widget.price)}",
                              style: const TextStyle(
                                  fontSize: 11, height: 1, color: Colors.grey)),
                        ]),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "R${doubleFormat(widget.getCostPerUnitOfMeasurement())} p/${widget.unitOfMeasurement}",
                    style: const TextStyle(fontSize: 23),
                  ),
                  // CartStepperInt(
                  //   value: _quantityAddedToCart,
                  //   alwaysExpanded: true,
                  //   numberSize: 2,
                  //   size: 24,
                  //   style: CartStepperTheme.of(context).copyWith(
                  //       radius: Radius.circular(5),
                  //       activeBackgroundColor: Colors.white,
                  //       activeForegroundColor: Colors.black,
                  //       border: Border.all(color: Colors.grey)),
                  //   didChangeCount: (count) {
                  //     setState(() {
                  //       _quantityAddedToCart = count;
                  //       // widget.addToCart(Text(widget.productName));
                  //     });
                  //   },
                  // ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
