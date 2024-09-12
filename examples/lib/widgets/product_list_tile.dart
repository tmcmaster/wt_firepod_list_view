import 'package:flutter/material.dart';
import 'package:wt_firepod_list_view_examples/models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final GestureTapCallback? onTap;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      subtitle: Text(product.id),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('\$${product.price.toStringAsFixed(2)}'),
          Text('${product.weight} kg'),
        ],
      ),
      onTap: onTap,
    );
  }
}
