import 'package:flutter/material.dart';
import 'package:wt_firebase_listview_examples/models/supplier.dart';

class SupplierListTile extends StatelessWidget {
  final Supplier supplier;
  final GestureTapCallback? onTap;

  const SupplierListTile({
    super.key,
    required this.supplier,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(supplier.name),
      subtitle: Text(supplier.code),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(supplier.id),
        ],
      ),
      onTap: onTap,
    );
  }
}
