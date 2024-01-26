import 'package:flutter/material.dart';

import '../components/product_icon.dart';
import '../components/product_field.dart';
import '../components/alert_widget.dart';

import '../database/database_operations.dart';

import '../util/utils.dart';

class ProductScreen extends StatefulWidget {
  String productKey;
  String barcode;
  String productName;
  String category;
  String retailer;
  double units;
  String unitOfMeasurement;
  double price;
  void Function(String, String, String, double, String, double) setProduct;
  void Function(String) setKey;

  ProductScreen(
      {Key? key,
      this.productKey = "",
      required this.barcode,
      this.productName = "",
      this.category = "Cheese",
      this.retailer = "",
      this.units = 0,
      this.unitOfMeasurement = "g",
      this.price = 0,
      required this.setProduct,
      required this.setKey})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreen();
}

class _ProductScreen extends State<ProductScreen> {
  bool _productNameHasError = false;
  bool _categoryHasError = false;
  bool _retailerHasError = false;
  bool _unitsHasError = false;
  bool _unitOfMeasurementHasError = false;
  bool _priceHasError = false;

  void _updateProductName(String productName) {
    widget.productName = productName;
  }

  void _updateCategory(String category) {
    setState(() {
      widget.category = category;
      widget.unitOfMeasurement = defaultUnitOfMeasurement(widget.category);
    });
  }

  void _updateRetailer(String retailer) {
    widget.retailer = retailer;
  }

  void _updateUnits(String units) {
    widget.units = double.tryParse(units) ?? 0;
  }

  void _updateUnitOfMeasurement(String unitOfMeasurement) {
    widget.unitOfMeasurement = unitOfMeasurement;
  }

  void _updatePrice(String price) {
    widget.price = double.tryParse(price) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Product',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.orange,
          toolbarHeight: 68,
          actions: [
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  setState(() {
                    _productNameHasError = false;
                    _categoryHasError = false;
                    _retailerHasError = false;
                    _unitsHasError = false;
                    _unitOfMeasurementHasError = false;
                    _priceHasError = false;
                  });
                  // Save
                  if (widget.productName == "") {
                    setState(() {
                      _productNameHasError = true;
                    });
                  }
                  if (widget.category == "") {
                    setState(() {
                      _categoryHasError = true;
                    });
                  }
                  if (widget.retailer == "") {
                    setState(() {
                      _retailerHasError = true;
                    });
                  }
                  if (widget.units <= 0) {
                    setState(() {
                      _unitsHasError = true;
                    });
                  }
                  if (widget.unitOfMeasurement == "") {
                    setState(() {
                      _unitOfMeasurementHasError = true;
                    });
                  }
                  if (widget.price <= 0) {
                    setState(() {
                      _priceHasError = true;
                    });
                  }

                  if (_productNameHasError |
                      _categoryHasError |
                      _retailerHasError |
                      _unitsHasError |
                      _unitOfMeasurementHasError |
                      _priceHasError) {
                    // Error found

                    List<String> alertMessages = [];

                    if (_productNameHasError | _retailerHasError) {
                      alertMessages.insert(
                          alertMessages.length, "Text field cannot be blank");
                    }
                    if (_unitsHasError | _priceHasError) {
                      alertMessages.insert(
                          alertMessages.length, "Number cannot be <= 0");
                    }

                    showAlertWidget(
                        context, flattenAlertMessages(alertMessages));
                  } else {
                    // No error, save product

                    if (widget.productKey == "") {
                      // Add new product
                      String key = addProductToDatabase(
                          widget.barcode,
                          widget.productName,
                          widget.category,
                          widget.retailer,
                          widget.units,
                          widget.unitOfMeasurement,
                          widget.price);

                      widget.setKey(key);
                    } else {
                      // Update existing product
                      updateProduct(
                          widget.productKey,
                          widget.productName,
                          widget.category,
                          widget.retailer,
                          widget.units,
                          widget.unitOfMeasurement,
                          widget.price);
                    }

                    widget.setProduct(
                        widget.productName,
                        widget.category,
                        widget.retailer,
                        widget.units,
                        widget.unitOfMeasurement,
                        widget.price);

                    Navigator.pop(context);

                    showAlertWidget(context, "Product saved!");
                  }
                })
          ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
        children: <Widget>[
          Row(
            children: [
              ProductIcon(
                category: widget.category,
                size: 75,
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              ),
              ProductField(
                header: "PRODUCT",
                widgets: [
                  TextFieldWidget(
                    textFieldHintText: "Enter the product name",
                    update: _updateProductName,
                    initialValue: widget.productName,
                    hasError: _productNameHasError,
                  )
                ],
                fineText: "Barcode: ${widget.barcode}",
              ),
            ],
          ),
          ProductField(header: "CATEGORY", widgets: [
            DropdownMenuWidget(
              dropdownItems: categories,
              update: _updateCategory,
              initialValue: widget.category,
              hasError: _categoryHasError,
            )
          ]),
          ProductField(header: "RETAILER", widgets: [
            // AutoCompleteWidget(
            TextFieldWidget(
              textFieldHintText: "Enter the retailer",
              update: _updateRetailer,
              initialValue: widget.retailer,
              hasError: _retailerHasError,
            )
          ]),
          ProductField(header: "AMOUNT", widgets: [
            TextFieldWidget(
              textFieldHintText: "Enter the units",
              acceptOnlyNumbers: true,
              update: _updateUnits,
              initialValue: widget.units.toString(),
              hasError: _unitsHasError,
            ),
            DropdownMenuWidget(
              dropdownItems: unitsOfMeasurement,
              width: 85,
              update: _updateUnitOfMeasurement,
              initialValue: widget.unitOfMeasurement,
              hasError: _unitOfMeasurementHasError,
            )
          ]),
          ProductField(header: "PRICE", widgets: [
            TextFieldWidget(
              textFieldHintText: "Enter the price",
              acceptOnlyNumbers: true,
              prefix: "R",
              update: _updatePrice,
              initialValue: widget.price.toString(),
              hasError: _priceHasError,
            )
          ])
        ],
      ),
    );
  }
}
