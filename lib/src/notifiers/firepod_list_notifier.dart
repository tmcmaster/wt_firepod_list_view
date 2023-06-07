import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_models/wt_models.dart';

class FirepodListNotifier<T extends TitleIdJsonSupport> extends StateNotifier<List<T>> {
  final Ref ref;

  final DatabaseReference Function(FirebaseDatabase table) table;
  List<T> Function(DataSnapshot snapshot) snapshotList;
  int Function(T a, T b)? sortWith;

  late StreamSubscription _subscription;

  FirepodListNotifier(
    this.ref, {
    required this.snapshotList,
    required this.table,
    this.sortWith,
  }) : super([]) {
    final database = ref.read(FirebaseProviders.database);
    _subscription = table(database).onValue.listen((event) {
      // print('Event ${event.type}');

      final newList = snapshotList(event.snapshot);

      if (sortWith != null) {
        newList.sort(sortWith);
      }

      state = newList;
    });
  }

  Future<void> refresh() async {
    final database = ref.read(FirebaseProviders.database);
    final snapshot = await table(database).get();
    state = snapshotList(snapshot);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
