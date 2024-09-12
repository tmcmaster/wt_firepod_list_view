import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_action_button/wt_action_button.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_firepod_list_view_examples/definitions/data_definitions.dart';
import 'package:wt_logging/wt_logging.dart';

class NormaliseOrderValuesAction extends ActionButtonDefinition {
  static final log = logger(NormaliseOrderValuesAction);

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
        log.d(error);
      }
    });
  }
}
