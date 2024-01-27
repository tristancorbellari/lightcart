import 'package:flutter/material.dart';

import '../presentation/barcode_scanner.dart';
import '../presentation/custom_route.dart';

import '../components/option_dialog.dart';
import '../components/list_item.dart';

import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _key = "";
  String _barcode = "";

  void setKey(String key) {
    setState(() {
      _key = key;
    });
  }

  void setBarcode(String barcode) {
    setState(() {
      _barcode = barcode;
    });
  }

  final List<ListItem> products = [
    // ListItem(
    //           category: "Cheese",
    //           productName: "Woolies Gouda",
    //           retailer: "Woolworths",
    //           units: 0.9,
    //           unitOfMeasurement: "g",
    //           price: 85),

    //       ListItem(
    //           category: "Milk",
    //           productName: "Woolies Gouda\nBig",
    //           retailer: "Woolworths",
    //           units: 1.2,
    //           unitOfMeasurement: "l",
    //           price: 115),

    //       ListItem(
    //           category: "Cheese",
    //           productName: "Woolies Cheddar",
    //           retailer: "Woolworths",
    //           units: 0.9,
    //           unitOfMeasurement: "g",
    //           price: 83),

    //       ListItem(
    //           category: "Cheese",
    //           productName: "Woolies Cheddar\nSmall",
    //           retailer: "Woolworths",
    //           units: 0.6,
    //           unitOfMeasurement: "g",
    //           price: 75),
  ];

  final List<Text> cartItems = [];

  void addNewProduct(String productName, String category, String retailer,
      double units, String unitOfMeasurement, double price) {
    setState(() {
      products.insert(
          0,
          ListItem(
            productKey: _key,
            barcode: _barcode,
            productName: productName,
            category: category,
            retailer: retailer,
            units: units,
            unitOfMeasurement: unitOfMeasurement,
            price: price,
            sortProducts: sortProducts,
          ));
    });
  }

  void sortProducts() {
    setState(() {
      _sortProducts();
    });
  }

  void _sortProducts() {
    products.sort((a, b) => a
        .getCostPerUnitOfMeasurement()
        .compareTo(b.getCostPerUnitOfMeasurement()));
  }

  void _clearProducts() {
    setState(() {
      products.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.orange,
        toolbarHeight: 68,
        actions: [
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                //CLEAR
                products.isNotEmpty
                    ? showOptionDialog(
                        context, "No", () {}, "Yes", _clearProducts)
                    : null;
              })
        ],
      ),
      body: products.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
              child: Center(
                  child: Column(children: [
                Text(
                  "Your list is empty",
                  style: TextStyle(fontSize: 26, color: Colors.grey[400]),
                ),
                Icon(Icons.icecream, size: 55, color: Colors.grey[400]),
                Text("Why not add some things?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]))
              ])))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                _sortProducts();
                return products[index];
              }),
      floatingActionButton: Container(
        height: 75.0,
        width: 75.0,
        child: FittedBox(
          child: FloatingActionButton(
            foregroundColor: Colors.purple[800],
            backgroundColor: Colors.purple[200],
            onPressed: () async {
              _barcode = "";
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRViewExample(setBarcode: setBarcode),
              ));
              if (!mounted) {
                return;
              }

              if (_barcode != "") {
                Navigator.push(
                    context,
                    buildPageWithSlideTransition(
                        context: context,
                        screen: ProductScreen(
                            barcode: _barcode,
                            setProduct: addNewProduct,
                            setKey: setKey)));
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
