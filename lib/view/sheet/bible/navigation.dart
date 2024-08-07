import 'package:flutter/material.dart';
// import 'package:scripture/widget/button.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-navigation';
  static String label = 'Navigation';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  // @override
  // ViewData get viewData => App.viewData;

  @override
  double get actualInitialSize => 0.9;
  @override
  double get actualMinSize => 0.4;

  late final RouteNotifier notifier = RouteNotifier();

  @override
  Widget draggableBody(ScrollController controller) {
    // return Scrollable(
    //   controller: controller,
    //   viewportBuilder: (_, __) {
    //     return child();
    //   },
    // );
    return child();
  }

  Widget child() {
    return NestedView(
      delegate: ReadDelegates(
        bridge: notifier,
        name: rootPath(Main.route),
        arguments: state.arguments,
        // root: state.name ?? TmpSheetHome.route,
        // route: routes,
      ),
    );
  }
}
