import 'package:flutter/material.dart';
import 'package:lidea/icon.dart';

/// NOTE: Core, Components
import '/app.dart';

class MenuBottom extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MenuBottom({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: App.core.bottom.factor,
      builder: (_, factor, child) {
        return Align(
          alignment: const Alignment(0, -1),
          heightFactor: factor,
          child: Padding(
            // padding: EdgeInsets.only(bottom: App.viewData.media.viewPadding.bottom),
            padding: const EdgeInsets.only(bottom: 0),
            child: bottomNavigationToggle(),
          ),
        );
      },
    );
  }

  Widget bottomNavigationToggle() {
    return ValueListenableBuilder<double>(
      valueListenable: App.core.bottom.toggle,
      builder: (context, toggle, child) {
        return Align(
          alignment: const Alignment(0, -1),
          heightFactor: toggle,
          // child: bottomNavigationDecoration(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).dividerColor,
                  offset: const Offset(0, -0.5),
                )
              ],
            ),
            child: bottomNavigationBar(context),
          ),
        );
      },
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // selectedIconTheme: Theme.of(context).iconTheme.copyWith(
      //       size: 25,
      //     ),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(LideaIcon.flag),
          label: 'Home',
          tooltip: context.lang.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(LideaIcon.bookOpen),
          label: 'Read',
          tooltip: context.lang.holyBible,
        ),
        BottomNavigationBarItem(
          icon: const Icon(LideaIcon.listNested),
          label: 'Note',
          tooltip: context.lang.note(''),
        ),
        BottomNavigationBarItem(
          icon: const Icon(LideaIcon.search),
          label: 'search',
          tooltip: context.lang.search(''),
        ),
      ],
      elevation: 0,
      currentIndex: shell.currentIndex,
      onTap: (index) {
        shell.goBranch(index, initialLocation: index == shell.currentIndex);
      },
    );
  }
}
