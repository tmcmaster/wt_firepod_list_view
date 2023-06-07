import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_models/wt_models.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
class Supplier extends TitleIdJsonSupport<Supplier> with _$Supplier {
  static final from = ToModelFromFirebase<Supplier>(json: _Supplier.fromJson, titles: _titles);
  static final to = FromModelToFirebase<Supplier>(titles: _titles);

  static final _titles = ['id', 'name'];

  factory Supplier({
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'name', defaultValue: '') required String name,
    @JsonKey(name: 'code', defaultValue: '') required String code,
  }) = _Supplier;

  Supplier._();

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

  @override
  String getId() => id;

  @override
  String getTitle() => name;
}
