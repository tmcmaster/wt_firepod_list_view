import 'package:wt_firebase_listview_examples/definitions/customer_definition.dart';
import 'package:wt_firebase_listview_examples/definitions/driver_definition.dart';
import 'package:wt_firebase_listview_examples/definitions/product_definition.dart';
import 'package:wt_firebase_listview_examples/definitions/supplier_definition.dart';

class DataDefinitions {
  static final customers = CustomerDefinition(
    orderBy: 'order',
  );
  static final suppliers = SupplierDefinition(
    orderBy: 'name',
  );
  static final drivers = DriverDefinition(
    orderBy: 'name',
  );
  static final allProducts = ProductDefinition(
    orderBy: 'order',
    sortWith: (a, b) => a.weight.compareTo(b.weight),
  );
  static final sfProducts = ProductDefinition(
    orderBy: 'supplier',
    equalTo: 'SF',
  );
}
