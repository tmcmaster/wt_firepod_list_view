import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_action_button/action_process_indicator.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_firepod_list_view/wt_firepod_list_view.dart';
import 'package:wt_firepod_list_view_examples/actions/normalise_order_values.dart';
import 'package:wt_firepod_list_view_examples/definitions/data_definitions.dart';
import 'package:wt_firepod_list_view_examples/models/product.dart';
import 'package:wt_firepod_list_view_examples/widgets/product_list_tile.dart';
import 'package:wt_firepod_list_view_examples/widgets/selected_item_view.dart';
import 'package:wt_logging/wt_logging.dart';

const debug = false;

class DatabaseExamplePage extends ConsumerWidget {
  static final log = logger(DatabaseExamplePage);

  const DatabaseExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseAction = ref.read(NormaliseOrderValuesAction.provider);
    final database = ref.read(FirebaseProviders.database);

    final examples = <Example>[
      DataDefinitionExample(
        'Products',
        DataDefinitions.allProducts,
        canReorder: true,
        canSelect: true,
      ),
      DataDefinitionExample('Suppliers', DataDefinitions.suppliers),
      DataDefinitionExample('Drivers', DataDefinitions.drivers),
      DataDefinitionExample('Customers', DataDefinitions.customers),
      Example(
        'Normalise Product Orders',
        Column(
          children: [
            databaseAction.component(label: 'Normalise Product Orders'),
            const SizedBox(
              height: 50,
            ),
            databaseAction.indicator(type: IndicatorType.linear),
          ],
        ),
      ),
      Example(
        'ProductListTile',
        FirepodModelView(
          query: database.ref('v1/product/003'),
          snapshotToModel: Product.from.snapshot,
          itemBuilder: (product) => SizedBox(
            width: 250,
            child: ProductListTile(product: product),
          ),
        ),
      ),
      Example(
        'FirepodDoubleView',
        FirepodDoubleView(
          query: database.ref('v1/product/002/price'),
          itemBuilder: (value) => Text('\$${value.toStringAsFixed(2)}'),
        ),
      ),
      Example(
        'SelectedItemsView',
        SelectedItemsView<Product>(selection: DataDefinitions.allProducts.selection),
      ),
      Example(
        'FirepodListView(Product)',
        SizedBox(
          height: 350,
          width: double.infinity,
          child: FirepodListView(
            table: (database) => database.ref('v1/product'),
            query: (table) => table.orderByChild('id'),
            snapshotToModel: Product.from.snapshot,
            mapToItem: Product.from.json,
            itemToMap: Product.to.firebaseMap,
            formItemDefinitions: DataDefinitions.allProducts.formItemDefinitions,
            itemBuilder: (product, _) => ProductListTile(
              product: product,
            ),
            selection: DataDefinitions.allProducts.selection,
          ),
        ),
      ),
      Example(
        'RiverpodList(Product)',
        Consumer(
          builder: (_, ref, __) {
            log.d('Consumer.build');
            final products = ref.watch(DataDefinitions.allProducts.provider);
            return products.isEmpty
                ? const Text('No products yet')
                : ProductListTile(product: products[0]);
          },
        ),
      ),
    ];

    return DefaultTabController(
      length: examples.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Example Page'),
          bottom: TabBar(
            isScrollable: true,
            tabs: examples
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(e.title),
                  ),
                )
                .toList(),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: examples.map((e) => e.widget).toList(),
          ),
        ),
      ),
    );
  }
}

class DataDefinitionExample extends Example {
  static final log = logger(DataDefinitionExample);
  DataDefinitionExample(
    String title,
    FirepodListDefinition definition, {
    bool canEdit = true,
    bool canSelect = false,
    bool canReorder = false,
  }) : super(
          title,
          SizedBox(
            height: 200,
            width: double.infinity,
            child: definition.component(
              canEdit: canEdit,
              canSelect: canSelect,
              canReorder: canReorder,
              onSelect: (model) {
                log.d('Selected: $model');
              },
            ),
          ),
        );
}

class Example {
  final String title;
  final Widget widget;

  Example(this.title, this.widget);
}
