import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_firepod_list_view_examples/models/customer.dart';
import 'package:wt_firepod_list_view_examples/models/driver.dart';
import 'package:wt_firepod_list_view_examples/models/supplier.dart';
import 'package:wt_models/wt_models.dart';

part 'delivery.freezed.dart';
part 'delivery.g.dart';

@freezed
class Delivery extends IdJsonSupport<Delivery> with _$Delivery {
  static final from = ToModelFromFirebase<Delivery>(json: _Delivery.fromJson, titles: _titles);
  static final to = FromModelToFirebase<Delivery>(titles: _titles);

  static final _titles = ['customer', 'driver', 'supplier'];

  factory Delivery({
    Customer? customer,
    Driver? driver,
    Supplier? supplier,
  }) = _Delivery;

  Delivery._();

  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

  @override
  String getId() => customer?.getId() ?? driver?.getId() ?? supplier?.getId() ?? '';
}
