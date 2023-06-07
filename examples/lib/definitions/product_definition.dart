import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:wt_firebase_listview/wt_firebase_listview.dart';
import 'package:wt_firebase_listview_examples/models/product.dart';
import 'package:wt_firebase_listview_examples/widgets/product_list_tile.dart';
import 'package:wt_firepod/wt_firepod.dart';

class ProductDefinition extends FirepodListDefinition<Product> {
  ProductDefinition({
    String path = 'v1/product',
    String orderBy = 'id',
    String? equalTo,
    int Function(Product a, Product b)? sortWith,
  }) : super(
          path: path,
          orderBy: orderBy,
          equalTo: equalTo,
          convertFrom: Product.from,
          convertTo: Product.to,
          sortWith: sortWith,
          formItemDefinitions: {
            'id': ModelFormDefinition<String>(
              label: 'ID',
              type: TextInputType.text,
              isUUID: true,
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
              readOnly: true,
            ),
            'title': ModelFormDefinition<String>(
              label: 'Title',
              type: TextInputType.text,
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            'order': ModelFormDefinition<double>(
              label: 'Order',
              type: TextInputType.number,
              initialValue: 0.0,
              validators: [
                FormBuilderValidators.required(),
              ],
              readOnly: true,
              hidden: true,
            ),
            'price': ModelFormDefinition<double>(
              label: 'Price',
              type: TextInputType.number,
              fromString: DataTransforms.stringToDouble,
              initialValue: 0.0,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            'weight': ModelFormDefinition<double>(
              label: 'Weight',
              type: TextInputType.number,
              fromString: DataTransforms.stringToDouble,
              initialValue: 0.0,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ],
            ),
          },
          itemBuilder: (product, _) => ProductListTile(
            product: product,
          ),
        );
}
