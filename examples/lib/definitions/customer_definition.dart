import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:wt_firebase_listview/wt_firebase_listview.dart';
import 'package:wt_firebase_listview_examples/models/customer.dart';
import 'package:wt_firebase_listview_examples/widgets/customer_list_tile.dart';
import 'package:wt_firepod/wt_firepod.dart';

class CustomerDefinition extends FirepodListDefinition<Customer> {
  CustomerDefinition({
    super.path = 'v1/customer',
    super.orderBy = 'order',
    super.equalTo,
    super.sortWith,
  }) : super(
          convertTo: Customer.to,
          convertFrom: Customer.from,
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
            'phone': ModelFormDefinition<String>(
              type: TextInputType.phone,
              label: 'Phone',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
                DataValidators.phone(),
              ],
            ),
            'email': ModelFormDefinition<String>(
              type: TextInputType.emailAddress,
              label: 'Email',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
            'address': ModelFormDefinition<String>(
              type: TextInputType.text,
              label: 'Address',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            'postcode': ModelFormDefinition<int>(
              type: TextInputType.number,
              fromString: DataTransforms.stringToInt,
              label: 'Postcode',
              initialValue: 0,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
          },
          itemBuilder: (customer, _) => CustomerListTile(
            customer: customer,
          ),
        );
}
