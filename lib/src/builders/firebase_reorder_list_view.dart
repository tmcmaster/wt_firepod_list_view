import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wt_logging/wt_logging.dart';

class FirebaseReorderDatabaseListView extends FirebaseDatabaseQueryBuilder {
  static final log = logger(FirebaseReorderDatabaseListView, level: Level.warning);

  final void Function(
    DataSnapshot sourceDoc,
    double newOrder,
  ) onReorder;

  /// {@macro firebase_ui.firebase_database_list_view}
  FirebaseReorderDatabaseListView({
    Key? key,
    required Query query,
    required FirebaseItemBuilder itemBuilder,
    int pageSize = 10,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    required this.onReorder,
  }) : super(
          key: key,
          query: query,
          pageSize: pageSize,
          builder: (context, snapshot, _) {
            print('ReorderableListView.builder');
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
                final sourceOrder = (sourceDoc.value as Map)['order'];
                bool dragDown = (oldIndex < newIndex);

                final nIndex = newIndex + (dragDown ? -1 : 0);

                final newPrevPos = nIndex + (dragDown ? 0 : -1);
                final newNextPos = nIndex + 1;

                log.d(
                    'SourcePos($oldIndex) NewPrevPos($newPrevPos) NewPos($nIndex) NewNextPos($newNextPos): SourceOrder($sourceOrder)');

                final newPosIsFirst = nIndex == 0;
                final newPosIsLast = nIndex + 1 == snapshot.docs.length;

                final prevOrder = newPosIsFirst
                    ? (snapshot.docs[0].value as Map)['order'] - 1
                    : (snapshot.docs[newPrevPos].value as Map)['order'];

                final nextOrder = newPosIsLast
                    ? (snapshot.docs[snapshot.docs.length - 1].value as Map)['order'] + 1
                    : (snapshot.docs[newNextPos].value as Map)['order'];

                final newOrder = (prevOrder + nextOrder) / 2;

                log.d(
                    'SourceOrder($sourceOrder) PrevOrder($prevOrder) NewPos($newOrder) NextPos($nextOrder)');

                onReorder(sourceDoc, newOrder);
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
            );
          },
        );
}
