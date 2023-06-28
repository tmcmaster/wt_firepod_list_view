import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_firebase_listview/src/builders/firebase_reorder_list_view.dart';
import 'package:wt_firebase_listview/src/firepod_list_tile.dart';
import 'package:wt_firebase_listview/src/firepod_selected_items.dart';
import 'package:wt_firebase_listview/src/model_form.dart';
import 'package:wt_firebase_listview/src/model_form_definition.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_models/wt_models.dart';

class FirepodListView<T extends TitleIdJsonSupport<T>> extends ConsumerWidget {
  static final log = logger(FirepodListView);

  final DatabaseReference Function(FirebaseDatabase database) table;
  final Query Function(DatabaseReference table) query;
  final T Function(DataSnapshot snapshot) snapshotToModel;
  final Widget Function(T model, BuildContext context) itemBuilder;
  final StateNotifierProvider<FirepodSelectedItems<T>, Set<T>> selection;
  final Map<String, ModelFormDefinition<dynamic>> formItemDefinitions;
  final T Function(Map<String, dynamic> json) mapToItem;
  final Map<String, dynamic> Function(T item) itemToMap;
  final void Function(T item)? onSelect;
  final bool canSelect;
  final bool canEdit;
  final bool canReorder;

  const FirepodListView({
    super.key,
    required this.table,
    required this.query,
    required this.snapshotToModel,
    required this.itemBuilder,
    required this.selection,
    required this.formItemDefinitions,
    required this.mapToItem,
    required this.itemToMap,
    this.onSelect,
    this.canSelect = false,
    this.canEdit = false,
    this.canReorder = false,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(FirebaseProviders.database);
    final selectionNotifier = ref.read(selection.notifier);
    final tableRef = table(database);
    final queryRef = query(tableRef);

    return canReorder
        ? FirebaseReorderDatabaseListView(
            query: queryRef,
            itemBuilder: (context, snapshot) => _buildItem(
              context,
              tableRef,
              snapshot,
              selectionNotifier,
              EdgeInsets.only(right: Platform.isMacOS || kIsWeb ? 40 : 0),
            ),
            onReorder: (srcDoc, newOrder) => _reorderItem(srcDoc, newOrder, tableRef),
          )
        : FirebaseDatabaseListView(
            query: queryRef,
            itemBuilder: (context, snapshot) => _buildItem(
              context,
              tableRef,
              snapshot,
              selectionNotifier,
              EdgeInsets.zero,
            ),
          );
  }

  void _reorderItem(
    DataSnapshot sourceDoc,
    double newOrder,
    DatabaseReference tableRef,
  ) {
    final key = sourceDoc.key;
    if (key != null) {
      final itemMap = (sourceDoc.value ?? {}) as Map;
      itemMap['order'] = newOrder;
      final ref = tableRef.child(key);
      ref.set(itemMap);
    } else {
      log.w('Could not reorder item because it did not have an id key.');
    }
  }

  Widget _buildItem(
    BuildContext context,
    DatabaseReference table,
    DataSnapshot snapshot,
    FirepodSelectedItems<T> selectionNotifier,
    EdgeInsets padding,
  ) {
    final model = snapshotToModel(snapshot);
    return FirepodListTile<T>(
      key: ValueKey(model.getId()),
      model: model,
      itemBuilder: (model) => itemBuilder(model, context),
      onDelete: (model) => _onDelete(model, table, context),
      onTap: (model) => onSelect?.call(model),
      onEdit: canEdit ? (model) => _onEdit(model, table, context) : null,
      onSelect:
          canSelect ? (model, isSelected) => _onSelect(model, isSelected, selectionNotifier) : null,
      initSelected: selectionNotifier.isSelected(model),
      padding: padding,
    );
  }

  void _onSelect(T model, bool selected, FirepodSelectedItems selection) {
    log.d('Selecting $model : $selected');
    if (selected) {
      selection.add(model);
    } else {
      selection.remove(model);
    }
  }

  void _onEdit(T model, DatabaseReference table, BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      animationType: DialogTransitionType.slideFromRight,
      alignment: Alignment.center,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add a new Website token'),
          ),
          body: ModelForm<T>(
            key: ValueKey('product ${model.getId()}'),
            item: model,
            mapToItem: mapToItem,
            itemToMap: itemToMap,
            formItemDefinitions: formItemDefinitions,
            onSubmit: (item) {
              log.d('onSubmit Edited: $item');
              _update(item, table);
            },
          ),
        );
      },
    );
  }

  void _onDelete(T model, DatabaseReference table, BuildContext context) {
    table.child(model.getId()).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () => _update(model, table),
        ),
        content: Text('Deleted: $model'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _update(T model, DatabaseReference table) {
    log.d('_update Edited: $model');
    final key = model.getId();
    final ref = table.child(key);
    final itemMap = itemToMap(model);
    ref.set(itemMap);
  }
}
