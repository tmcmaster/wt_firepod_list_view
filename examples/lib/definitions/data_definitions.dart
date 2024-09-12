import 'package:wt_firepod_list_view_examples/definitions/customer_definition.dart';
import 'package:wt_firepod_list_view_examples/definitions/driver_definition.dart';
import 'package:wt_firepod_list_view_examples/definitions/product_definition.dart';
import 'package:wt_firepod_list_view_examples/definitions/supplier_definition.dart';

mixin DataDefinitions {
  static final customers = CustomerDefinition();
  static final suppliers = SupplierDefinition();
  static final drivers = DriverDefinition();
  static final allProducts = ProductDefinition(
    orderBy: 'order',
    sortWith: (a, b) => a.weight.compareTo(b.weight),
  );
  static final sfProducts = ProductDefinition(
    orderBy: 'supplier',
    equalTo: 'SF',
  );
}
