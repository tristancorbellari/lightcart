import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../components/alert_widget.dart';
import '../presentation/barcode_scanner.dart';
import '../presentation/custom_route.dart';
import '../presentation/loading_circle.dart';

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

  void _addNewProduct(String productKey, String productName, String category,
      String retailer, double units, String unitOfMeasurement, double price) {
    products.insert(
        0,
        ListItem(
          productKey: productKey,
          barcode: _barcode,
          productName: productName,
          category: category,
          retailer: retailer,
          units: units,
          unitOfMeasurement: unitOfMeasurement,
          price: price,
          sortProducts: sortProducts,
        ));
  }

  void setProduct(String productKey, String productName, String category,
      String retailer, double units, String unitOfMeasurement, double price) {
    setState(() {
      var contain =
          products.where((element) => element.productKey == productKey);
      if (contain.isEmpty) {
        // Add new product
        _addNewProduct(productKey, productName, category, retailer, units,
            unitOfMeasurement, price);
      } else {
        // Update product
        for (ListItem listItem in contain) {
          products.removeWhere(
              (element) => element.productKey == listItem.productKey);

          _addNewProduct(productKey, productName, category, retailer, units,
              unitOfMeasurement, price);
        }
      }
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

  void _clearProducts() async {
    setState(() {
      products.clear();
    });

    await products.isEmpty;

    showAlertWidget(context, "Product list cleared!");
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
                // Clear items list
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
              _key = "";
              _barcode = "";
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRViewExample(setBarcode: setBarcode),
              ));
              if (!mounted) {
                return;
              }

              if (_barcode != "") {
                buildLoading(context);

                DatabaseReference databaseReference =
                    FirebaseDatabase.instance.ref().child('products');

                bool addedProduct = false;

                databaseReference
                    .orderByChild('Barcode')
                    .equalTo(_barcode)
                    .onValue
                    .listen((event) {
                  if (!addedProduct) {
                    addedProduct = true;

                    bool foundValues = false;

                    String _productKey = "",
                        _name = "",
                        _category = "",
                        _retailer = "",
                        _unitOfMeasurement = "";
                    double _units = 0.0, _price = 0.0;

                    DataSnapshot snapshot = event.snapshot;

                    Navigator.pop(context);

                    Map<dynamic, dynamic>? map;
                    try {
                      map = snapshot.value as Map<dynamic, dynamic>;
                    } catch (e) {}
                    ;

                    map?.forEach((key, value) {
                      // Display existing record

                      foundValues = true;

                      _productKey = key;
                      _name = value['Name'];
                      _category = value['Category'];
                      _retailer = value['Retailer'];
                      _units = value['Units'].toDouble();
                      _unitOfMeasurement = value['UoM'];
                      _price = value['Price'].toDouble();
                    });
                    if (foundValues) {
                      Navigator.push(
                          context,
                          buildPageWithSlideTransition(
                              context: context,
                              screen: ProductScreen(
                                  productKey: _productKey,
                                  barcode: _barcode,
                                  productName: _name,
                                  category: _category,
                                  retailer: _retailer,
                                  units: _units,
                                  unitOfMeasurement: _unitOfMeasurement,
                                  price: _price,
                                  setProduct: setProduct,
                                  setKey: (String) {})));
                    } else {
                      Navigator.push(
                          context,
                          buildPageWithSlideTransition(
                              context: context,
                              screen: ProductScreen(
                                  barcode: _barcode,
                                  setProduct: setProduct,
                                  setKey: setKey)));
                    }
                  }
                });
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
