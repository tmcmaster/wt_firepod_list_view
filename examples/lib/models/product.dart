import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_models/wt_models.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product extends OrderTitleIdJsonSupport<Product> with _$Product {
  static final from = ToModelFromFirebase<Product>(json: _Product.fromJson, titles: _titles);
  static final to = FromModelToFirebase<Product>(titles: _titles);

  static final _titles = ['id', 'title', 'price', 'weight'];

  factory Product({
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'title', defaultValue: '') required String title,
    @JsonKey(name: 'order', defaultValue: 0.0) required double order,
    @JsonKey(name: 'price', defaultValue: 0.0) required double price,
    @JsonKey(name: 'weight', defaultValue: 0.0) required double weight,
  }) = _Product;

  Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  String getId() => id ?? '';

  @override
  String getTitle() => title ?? '';

  @override
  double getOrder() => order ?? 0;
}
