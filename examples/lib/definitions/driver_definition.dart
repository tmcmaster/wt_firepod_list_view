import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:wt_firepod_list_view/wt_firepod_list_view.dart';
import 'package:wt_firepod_list_view_examples/models/driver.dart';
import 'package:wt_firepod_list_view_examples/widgets/driver_list_tile.dart';

class DriverDefinition extends FirepodListDefinition<Driver> {
  DriverDefinition({
    super.path = 'v1/driver',
    super.orderBy = 'name',
    super.equalTo,
    super.sortWith,
  }) : super(
          convertFrom: Driver.from,
          convertTo: Driver.to,
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
              type: TextInputType.text,
              label: 'Phone',
              initialValue: '',
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
          },
          itemBuilder: (driver, _) => DriverListTile(
            driver: driver,
          ),
        );
}
