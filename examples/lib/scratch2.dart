import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wt_firebase_listview_examples/models/customer.dart';
import 'package:wt_firebase_listview_examples/models/delivery.dart';
import 'package:wt_firebase_listview_examples/models/driver.dart';
import 'package:wt_firebase_listview_examples/models/supplier.dart';
import 'package:wt_models/wt_models.dart';

final Map<int, Color> colorMapper = {
  0: Colors.white,
  1: Colors.blueGrey[50]!,
  2: Colors.blueGrey[100]!,
  3: Colors.blueGrey[200]!,
  4: Colors.blueGrey[300]!,
  5: Colors.blueGrey[400]!,
  6: Colors.blueGrey[500]!,
  7: Colors.blueGrey[600]!,
  8: Colors.blueGrey[700]!,
  9: Colors.blueGrey[800]!,
  10: Colors.blueGrey[900]!,
};

extension ColorUtil on Color {
  Color byLuminance() => this.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;
}

const showSnackBar = false;
const expandChildrenOnReady = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Animated Tree Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Simple Animated Tree Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TreeViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: sampleTree.expansionNotifier,
        builder: (context, isExpanded, _) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (sampleTree.isExpanded) {
                _controller?.collapseNode(sampleTree);
              } else {
                _controller?.expandAllChildren(sampleTree);
              }
            },
            label: isExpanded ? const Text("Collapse all") : const Text("Expand all"),
          );
        },
      ),
      body: TreeView.simple(
        tree: sampleTree,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) => ChevronIndicator.rightDown(
          tree: node,
          color: Colors.blue[700],
          padding: const EdgeInsets.all(8),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onItemTap: (item) {
          if (kDebugMode) print("Item tapped: ${item.key}");

          if (showSnackBar) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Item tapped: ${item.key}"),
                duration: const Duration(milliseconds: 750),
              ),
            );
          }
        },
        onTreeReady: (controller) {
          _controller = controller;
          if (expandChildrenOnReady) controller.expandAllChildren(sampleTree);
        },
        builder: (context, node) => Card(
          color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
          child: ListTile(
            title: Text(node.data.toString()),
            subtitle: Text(''),
          ),
        ),
      ),
    );
  }
}

final customer = Customer(
  id: '001',
  name: 'Customer 1',
  phone: '040400001',
  email: 'customer+1@example.com',
  address: '1 main street, Pakenham',
  postcode: 3810,
);

final supplier = Supplier(id: '001', name: 'Supplier 1', code: 'SUP1');
final driver = Driver(id: '001', name: 'Driver 1', phone: '0404111111');
final delivery = Delivery(
  customer: customer,
  supplier: supplier,
  driver: driver,
);
final dataList1 = ['First', dataMap2, 'Last', delivery];

final dataMap1 = {
  'a': 'A',
  'b': 'B',
  'c': {
    'cc': 'C',
    'dd': 'D',
    'ee': 'E',
    'ff': 'F',
  },
};

final dataList2 = ['AAA', dataMap1, 'CCC'];

final dataMap2 = {
  'a': 'AA',
  'b': 'BB',
  'c': {
    'cc': 'CC',
    'dd': 'DD',
    'ee': dataList2,
    'ff': 'FF',
  },
};

int keyIndex = 0;
String nextKey() {
  return (++keyIndex).toString();
}

final sampleTree = listToTreeNode(dataList1);

TreeNode listToTreeNode(List<dynamic> list) {
  final parent = TreeNode(key: nextKey(), data: 'Root Node');
  _walkList(list, parent);
  return parent;
}

TreeNode mapToTreeNode(Map map) {
  final parent = TreeNode(key: nextKey(), data: 'Root Node');
  _walkMap(map, parent);
  return parent;
}

void _walkMap(Map map, TreeNode parent) {
  for (final entry in map.entries) {
    if (entry.value is String ||
        entry.value is int ||
        entry.value is double ||
        entry.value is bool) {
      parent.add(TreeNode(key: nextKey(), data: '${entry.key} : ${entry.value}'));
    } else if (entry.value is Map) {
      final mapParent = TreeNode(key: nextKey(), data: 'Map : ${entry.key}');
      _walkMap(entry.value as Map, mapParent);
      parent.add(mapParent);
    } else if (entry.value is List) {
      final listParent = TreeNode(key: nextKey(), data: 'List : ${entry.key}');
      _walkList(entry.value as List, listParent);
      parent.add(listParent);
    } else if (entry.value is JsonSupport) {
      final jsonData = (entry.value as JsonSupport).toJson();
      _walkObject(jsonData, parent);
    }
  }
}

void _walkList(List<dynamic> list, TreeNode parent) {
  for (final item in list) {
    if (item is String || item is int || item is double || item is bool) {
      parent.add(TreeNode(key: nextKey(), data: item));
    } else if (item is Map<String, dynamic>) {
      final mapParent = TreeNode(key: nextKey(), data: 'Map');
      parent.add(mapParent);
      _walkMap(item, mapParent);
    } else if (item is List) {
      final listParent = TreeNode(key: nextKey(), data: 'List');
      parent.add(listParent);
      _walkList(item, listParent);
    } else if (item is JsonSupport) {
      final jsonData = item.toJson();
      _walkObject(jsonData, parent);
    }
  }
}

void _walkObject(dynamic object, TreeNode parent) {
  if (object is String || object is int || object is double || object is bool) {
    parent.add(TreeNode(key: nextKey(), data: object.toString()));
  } else if (object is Map) {
    final mapParent = TreeNode(key: nextKey(), data: 'Map');
    parent.add(mapParent);
    _walkMap(object, mapParent);
  } else if (object is List) {
    final listParent = TreeNode(key: nextKey(), data: 'List');
    parent.add(listParent);
    _walkList(object, listParent);
  } else {}
}
