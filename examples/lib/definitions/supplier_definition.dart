import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:wt_firebase_listview/wt_firebase_listview.dart';
import 'package:wt_firebase_listview_examples/models/supplier.dart';
import 'package:wt_firebase_listview_examples/widgets/supplier_list_tile.dart';

class SupplierDefinition extends FirepodListDefinition<Supplier> {
  SupplierDefinition({
    super.path = 'v1/supplier',
    super.orderBy = 'name',
    super.equalTo,
    super.sortWith,
  }) : super(
          convertFrom: Supplier.from,
          convertTo: Supplier.to,
          formItemDefinitions: {
            'id': ModelFormDefinition<String>(
              type: TextInputType.text,
              label: 'ID',
              isUUID: true,
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
              readOnly: true,
            ),
            'name': ModelFormDefinition<String>(
              type: TextInputType.text,
              label: 'Title',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            'code': ModelFormDefinition<String>(
              type: TextInputType.text,
              label: 'Code',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
          },
          itemBuilder: (supplier, _) => SupplierListTile(
            supplier: supplier,
          ),
        );
}
