import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_models/wt_models.dart';

class FirepodSelectedItems<T extends IdSupport> extends StateNotifier<Set<T>> {
  FirepodSelectedItems() : super({});

  bool isSelected(T item) {
    return state.contains(item);
  }

  void add(T item) {
    state = {...state, item};
    print(state);
  }

  void remove(T item) {
    state = {...state..remove(item)};
    print(state);
  }
}
