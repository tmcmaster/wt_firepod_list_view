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
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'name', defaultValue: '') required String name,
    @JsonKey(name: 'phone', defaultValue: '') required String phone,
    @JsonKey(name: 'email', defaultValue: '') required String email,
    @JsonKey(name: 'address', defaultValue: '') required String address,
    @JsonKey(name: 'postcode', defaultValue: 0) required int postcode,
  }) = _Customer;

  Customer._();

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  @override
  String getId() => id;

  @override
  String getTitle() => name;
}
