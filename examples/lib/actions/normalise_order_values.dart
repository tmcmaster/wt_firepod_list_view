import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_action_button/utils/logging.dart';
import 'package:wt_action_button/wt_action_button.dart';
import 'package:wt_firebase_listview_examples/definitions/data_definitions.dart';
import 'package:wt_firepod/wt_firepod.dart';

class NormaliseOrderValuesAction extends ActionButtonDefinition {
  static final log = logger(NormaliseOrderValuesAction, level: Level.debug);

  static final provider = Provider(
    name: 'Normalise Order Values',
    (ref) => NormaliseOrderValuesAction(ref),
  );

  NormaliseOrderValuesAction(super.ref)
      : super(
          label: 'Normalise Order Values Action',
          icon: FontAwesomeIcons.database,
        );

  @override
  Future<void> execute() async {
    final notifier = ref.read(progress.notifier);
    notifier.run(() async {
      try {
        await ref.read(DataDefinitions.allProducts.provider.notifier).refresh();
        final list = ref.read(DataDefinitions.allProducts.provider);
        normaliseOrderValue(list: list, ref: ref, path: 'v1/products');
      } catch (error) {
        print(error);
      }
    });
  }
}
