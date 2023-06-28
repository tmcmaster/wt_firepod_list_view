import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wt_logging/wt_logging.dart';

class FirebaseReorderDatabaseListView extends FirebaseDatabaseQueryBuilder {
  static final log = logger(FirebaseReorderDatabaseListView);

  final void Function(
    DataSnapshot sourceDoc,
    double newOrder,
  ) onReorder;

  /// {@macro firebase_ui.firebase_database_list_view}
  FirebaseReorderDatabaseListView({
    super.key,
    required super.query,
    super.pageSize = 10,
    required FirebaseItemBuilder itemBuilder,
    FirebaseLoadingBuilder? loadingBuilder,
    FirebaseErrorBuilder? errorBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsets? padding,
    double? itemExtent,
    Widget? prototypeItem,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    required this.onReorder,
  }) : super(
          builder: (context, snapshot, _) {
            log.d('ReorderableListView.builder');
            if (snapshot.isFetching) {
              return loadingBuilder?.call(context) ??
                  const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError && errorBuilder != null) {
              return errorBuilder(
                context,
                snapshot.error!,
                snapshot.stackTrace!,
              );
            }

            return ReorderableListView.builder(
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                log.v('ReorderableListView.builder');
                final isLastItem = index + 1 == snapshot.docs.length;
                if (isLastItem && snapshot.hasMore) snapshot.fetchMore();

                final doc = snapshot.docs[index];
                return itemBuilder(context, doc);
              },
              onReorder: (oldIndex, newIndex) {
                log.d('onOrder($oldIndex, $newIndex)');

                final sourceDoc = snapshot.docs[oldIndex];
                final sourceOrder = _getOrder(snapshot, oldIndex);

                final dragDown = oldIndex < newIndex;

                final nIndex = newIndex + (dragDown ? -1 : 0);

                final newPrevPos = nIndex + (dragDown ? 0 : -1);
                final newNextPos = nIndex + 1;

                log.d(
                  'SourcePos($oldIndex) NewPrevPos($newPrevPos) NewPos($nIndex) NewNextPos($newNextPos): SourceOrder($sourceOrder)',
                );

                log.d('sdsddfsff fsdf sf');
                final newPosIsFirst = nIndex == 0;
                final newPosIsLast = nIndex + 1 == snapshot.docs.length;

                final prevOrder =
                    newPosIsFirst ? _getOrder(snapshot, 0) : _getOrder(snapshot, newPrevPos);

                final nextOrder = newPosIsLast
                    ? _getOrder(snapshot, snapshot.docs.length - 1)
                    : _getOrder(snapshot, newNextPos);

                if (prevOrder != null && nextOrder != null) {
                  final newOrder = (prevOrder + nextOrder) / 2;

                  log.d(
                    'SourceOrder($sourceOrder) PrevOrder($prevOrder) NewPos($newOrder) NextPos($nextOrder)',
                  );

                  onReorder(sourceDoc, newOrder);
                } else {
                  log.w(
                    'SourceOrder($sourceOrder) PrevOrder($prevOrder) NewPos() NextPos($nextOrder)',
                  );
                }
              },
              scrollDirection: scrollDirection,
              reverse: reverse,
              primary: primary,
              physics: physics,
              shrinkWrap: shrinkWrap,
              padding: padding,
              itemExtent: itemExtent,
              prototypeItem: prototypeItem,
              cacheExtent: cacheExtent,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              restorationId: restorationId,
              clipBehavior: clipBehavior,
              scrollController: controller,
            );
          },
        );

  static double? _getOrder(FirebaseQueryBuilderSnapshot snapshot, int index) {
    final value = snapshot.docs[index].value;
    final map = value == null ? null : value as Map;
    final order = map == null || (map.length - 1) < index ? null : map['order'] as num;
    return order == null ? null : double.parse(order.toString());
  }
}
