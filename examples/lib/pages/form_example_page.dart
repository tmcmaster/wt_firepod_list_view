import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_firebase_listview/wt_firebase_listview.dart';
import 'package:wt_firebase_listview_examples/models/product.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_logging/wt_logging.dart';

final selectedItemsProvider = StateNotifierProvider<FirepodSelectedItems<Product>, Set<Product>>(
  (ref) => FirepodSelectedItems<Product>(),
);

const debug = false;

class FormExamplePage extends StatefulWidget {
  const FormExamplePage({super.key});

  @override
  State<FormExamplePage> createState() => _FormExamplePageState();
}

class _FormExamplePageState extends State<FormExamplePage> {
  static final log = logger(FormExamplePage);

  final _formKey = GlobalKey<FormBuilderState>();

  double stringTpDouble(String? value) => value == null ? 0 : double.parse(value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Example Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (_, ref, __) {
                  return Text(
                    ref.read(FirebaseProviders.auth).currentUser?.email ?? 'Not Logged In',
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Add a new Website token'),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilder(
                            key: _formKey,
                            // enabled: false,
                            onChanged: () {
                              _formKey.currentState!.save();
                              log.d(_formKey.currentState!.value.toString());
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                            initialValue: const {
                              'id': '001',
                              'title': 'One',
                              'price': '1',
                              'weight': '11',
                            },
                            skipDisabled: true,
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  key: const ValueKey('Form:id'),
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'id',
                                  decoration: const InputDecoration(
                                    labelText: 'ID',
                                  ),
                                  onChanged: (val) {},
                                  // valueTransformer: (text) => num.tryParse(text),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  key: const ValueKey('Form:title'),
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'title',
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                  ),
                                  onChanged: (val) {},
                                  // valueTransformer: (text) => num.tryParse(text),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  key: const ValueKey('Form:price'),
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'price',
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  onChanged: (val) {},
                                  valueTransformer: stringTpDouble,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  key: const ValueKey('Form:weight'),
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'weight',
                                  decoration: const InputDecoration(
                                    labelText: 'Weight',
                                  ),
                                  onChanged: (val) {},
                                  valueTransformer: stringTpDouble,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _persistItem();
                                      },
                                      icon: const Icon(FontAwesomeIcons.floppyDisk),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _persistItem() {
    _formKey.currentState!.save();

    final map = {..._formKey.currentState!.value};
    final product = Product.from.json(map);
    log.d(product);
  }
}
