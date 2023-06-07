import 'package:flutter/material.dart';
import 'package:wt_firebase_listview_examples/models/driver.dart';

class DriverListTile extends StatelessWidget {
  final Driver driver;
  final GestureTapCallback? onTap;

  const DriverListTile({
    super.key,
    required this.driver,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // print('Building: ProductListTile ${product.title}');
    return ListTile(
      title: Text(driver.name),
      subtitle: Text(driver.phone),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(driver.id),
        ],
      ),
      onTap: onTap,
    );
  }
}
