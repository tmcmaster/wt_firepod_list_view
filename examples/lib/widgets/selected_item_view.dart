import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_firebase_listview/wt_firebase_listview.dart';
import 'package:wt_models/wt_models.dart';

class SelectedItemsView<T extends TitleIdJsonSupport<T>> extends ConsumerWidget {
  final StateNotifierProvider<FirepodSelectedItems<T>, Set<T>> selection;

  const SelectedItemsView({
    super.key,
    required this.selection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selection);

    return Consumer(
      builder: (_, ref, __) => Row(
        children: selected
            .map((i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(i.getTitle()),
                ))
            .toList(),
      ),
    );
  }
}
