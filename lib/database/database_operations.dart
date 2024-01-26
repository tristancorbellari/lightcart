import 'package:firebase_database/firebase_database.dart';

void updateProduct(String key, String productName, String category,
    String retailer, double units, String unitOfMeasurement, double price) {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('products');

  databaseReference.child(key).set({
    'Name': productName,
    'Category': category,
    'Retailer': retailer,
    'Units': units,
    'UoM': unitOfMeasurement,
    'Price': price,
  });
}

String addProductToDatabase(String barcode, String productName, String category,
    String retailer, double units, String unitOfMeasurement, double price) {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('products');
  final newPostKey =
      FirebaseDatabase.instance.ref().child('products').push().key;
  databaseReference.child(newPostKey!).set({
    'Barcode': barcode,
    'Name': productName,
    'Category': category,
    'Retailer': retailer,
    'Units': units,
    'UoM': unitOfMeasurement,
    'Price': price,
  });
  return newPostKey;
}
