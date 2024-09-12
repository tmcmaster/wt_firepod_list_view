import 'package:flutter/material.dart';
import 'package:wt_firepod_list_view_examples/models/customer.dart';

class CustomerListTile extends StatelessWidget {
  final Customer customer;
  final GestureTapCallback? onTap;

  const CustomerListTile({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(customer.name),
      subtitle: Text(customer.phone),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(customer.address),
          Text(customer.postcode.toString()),
        ],
      ),
      onTap: onTap,
    );
  }
}
