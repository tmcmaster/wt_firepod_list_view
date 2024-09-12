import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_firepod_list_view/src/firepod_list_view.dart';
import 'package:wt_firepod_list_view/src/firepod_selected_items.dart';
import 'package:wt_firepod_list_view/src/model_form_definition.dart';
import 'package:wt_firepod_list_view/src/notifiers/firepod_list_notifier.dart';

import 'package:wt_models/wt_models.dart';

class FirepodListDefinition<T extends TitleIdJsonSupport<T>> {
  final StateNotifierProvider<FirepodSelectedItems<T>, Set<T>> selection =
      StateNotifierProvider<FirepodSelectedItems<T>, Set<T>>(
    (ref) => FirepodSelectedItems<T>(),
  );

  late StateNotifierProvider<FirepodListNotifier<T>, List<T>> provider;

  late DatabaseReference Function(FirebaseDatabase table) table;
  late Query Function(DatabaseReference table) query;
  final Widget Function(T model, BuildContext context) itemBuilder;
  final Map<String, ModelFormDefinition<dynamic>> formItemDefinitions;
  final ToModelFromFirebase<T> convertFrom;
  final FromModelToFirebase<T> convertTo;
  final int Function(T a, T b)? sortWith;

  FirepodListDefinition({
    required String path,
    String? orderBy,
    String? equalTo,
    required this.itemBuilder,
    required this.formItemDefinitions,
    required this.convertFrom,
    required this.convertTo,
    required this.sortWith,
  }) {
    table = (database) => database.ref(path);
    query = (table) => orderBy == null
        ? table
        : equalTo == null
            ? table.orderByChild(orderBy)
            : table.orderByChild(orderBy).equalTo(equalTo);

    provider = StateNotifierProvider<FirepodListNotifier<T>, List<T>>(
      name: 'orderedProductListProvider',
      (ref) => FirepodListNotifier<T>(
        ref,
        snapshotList: convertFrom.snapshotList,
        table: table,
        sortWith: sortWith,
      ),
    );
  }

  Widget component({
    bool canSelect = false,
    bool canEdit = false,
    bool canReorder = false,
    void Function(T item)? onSelect,
  }) {
    return FirepodListView<T>(
      table: table,
      query: query,
      snapshotToModel: convertFrom.snapshot,
      mapToItem: convertFrom.json,
      itemToMap: convertTo.firebaseMap,
      formItemDefinitions: formItemDefinitions,
      itemBuilder: (model, context) => itemBuilder(model, context),
      selection: selection,
      canSelect: canSelect,
      canEdit: canEdit,
      onSelect: onSelect,
      canReorder: canReorder,
    );
  }
}
