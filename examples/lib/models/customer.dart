import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_models/wt_models.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer extends TitleIdJsonSupport<Customer> with _$Customer {
  static final from = ToModelFromFirebase<Customer>(json: _Customer.fromJson, titles: _titles);
  static final to = FromModelToFirebase<Customer>(titles: _titles);

  static final _titles = ['id', 'name'];

  factory Customer({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String address,
    required int postcode,
  }) = _Customer;

  Customer._();

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  @override
  String getId() => id;

  @override
  String getTitle() => name;
}
