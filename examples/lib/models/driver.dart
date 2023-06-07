import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_models/wt_models.dart';

part 'driver.freezed.dart';
part 'driver.g.dart';

@freezed
class Driver extends TitleIdJsonSupport<Driver> with _$Driver {
  static final from = ToModelFromFirebase<Driver>(json: _Driver.fromJson, titles: _titles);
  static final to = FromModelToFirebase<Driver>(titles: _titles);

  static final _titles = ['id', 'name', 'phone'];

  factory Driver({
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'name', defaultValue: '') required String name,
    @JsonKey(name: 'phone', defaultValue: '') required String phone,
  }) = _Driver;

  Driver._();

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  @override
  String getId() => id;

  @override
  String getTitle() => name;
}
