const List<String> categories = <String>['Cheese', 'Meat', 'Milk', 'Eggs'];
const List<String> unitsOfMeasurement = <String>['g', 'kg', 'l', 'ea'];

String doubleFormat(double num) {
  return num.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
}

String defaultUnitOfMeasurement(String category) {
  return unitsOfMeasurement
      .elementAt(categories.indexWhere((element) => element == category));
}

String shortenString(String s) {
  String result = s;
  if (result.length > 23) {
    result = "${result.substring(0, 20)}...";
  }
  return result;
}
