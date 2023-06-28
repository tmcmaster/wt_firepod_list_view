import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_models/wt_models.dart';

class FirepodSelectedItems<T extends IdSupport> extends StateNotifier<Set<T>> {
  static final log = logger(FirepodSelectedItems);
  FirepodSelectedItems() : super({});

  bool isSelected(T item) {
    return state.contains(item);
  }

  void add(T item) {
    state = {...state, item};
    log.d(state);
  }

  void remove(T item) {
    state = {...state..remove(item)};
    log.d(state);
  }
}
