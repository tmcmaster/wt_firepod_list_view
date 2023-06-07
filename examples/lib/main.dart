import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_firebase_listview_examples/app_secrets.dart';
import 'package:wt_firebase_listview_examples/firebase_options.dart';
import 'package:wt_firebase_listview_examples/pages/database_example_page.dart';
import 'package:wt_firepod/wt_firepod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    name: 'firepodExampleApp',
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((app) {
    FirebaseAuth.instanceFor(app: app)
        .signInWithEmailAndPassword(
      email: AppSecrets.userName,
      password: AppSecrets.password,
    )
        .then((user) {
      runApp(ProviderScope(
        overrides: [
          FirebaseProviders.database.overrideWithValue(FirebaseDatabase.instanceFor(app: app)),
          FirebaseProviders.auth.overrideWithValue(FirebaseAuth.instanceFor(app: app)),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => const HomePage(),
            '/examples': (context) => const DatabaseExamplePage(),
          },
          initialRoute: '/',
        ),
      ));
    }, onError: (error) {
      print('LOGIN ERROR: $error');
    });
  }, onError: (error) {
    debugPrint('ERROR: $error');
  });
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(FirebaseProviders.database);
    print('dsafasdfasdfadsf');
    print(database);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/examples');
          },
          child: const Text('Examples'),
        ),
      ),
    );
  }
}
