import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
// import 'package:lidea/share.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';
// import '/widget/profile_icon.dart';
// import '/widget/button.dart';
import '/widget/verse.dart';

part 'state.dart';
part 'header.dart';
part 'snackbar.dart';
part 'motile.dart';

// swipChapter dragChapter GestureChapter

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'read';
  static String label = 'Read';
  static IconData icon = LideaIcon.bookOpen;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('read->build');
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // debugPrint("statusBarHeight $statusBarHeight $");
    return Scaffold(
      key: _scaffoldKey,
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
          height: 120,
          pointer: 20,
        ),
        // scrollBottomNavigation: ScrollBottomNavigation()
        child: Motile(
          child: CustomScrollView(
            controller: _controller,
            slivers: _slivers,
          ),
        ),
        // child: CustomScrollView(
        //   controller: _controller,
        //   slivers: _slivers,
        // ),
      ),
      // resizeToAvoidBottomInset: true,
      // extendBody: true,
      // bottomNavigationBar: const SheetStack(),
      // bottomNavigationBar: App.route.show('sheet-parallel').child,
      bottomNavigationBar: ViewDelays.milliseconds(
        milliseconds: 1500,
        builder: (_, __) {
          return App.route.show('sheet-parallel').child;
        },
      ),
      // bottomSheet: App.route.show('sheet-parallel').child,
      // extendBody: true,
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        // padding: EdgeInsets.only(top: statusBarHeight),
        heights: const [kToolbarHeight - 20, 20],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      ViewFlats(
        child: ValueListenableBuilder<String>(
          valueListenable: App.core.message,
          builder: (_, message, child) {
            if (message.isEmpty) return child!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(message),
              ),
            );
          },
          child: const SizedBox(),
        ),
      ),
      StreamBuilder(
        initialData: data.boxOfSettings.fontSize(),
        stream: data.boxOfSettings.watch(key: 'fontSize'),
        builder: (BuildContext _, e) {
          return Selector<Core, CacheBible>(
            selector: (_, e) => e.scripturePrimary.read,
            builder: (BuildContext _, CacheBible bible, Widget? ___) {
              return ViewSections(
                sliver: true,
                footerTitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Paragraphs(
                    text: '{{description}}',
                    textAlign: TextAlign.center,
                    style: state.textTheme.labelSmall,
                    decoration: [
                      // TextSpan(
                      //   // text: 'App.data.cacheBible',
                      //   text: primaryScripture.info.langCode,
                      //   semanticsLabel: 'language',
                      //   style: TextStyle(
                      //     color: state.theme.highlightColor,
                      //   ),
                      // ),
                      TextSpan(
                        // text: 'App.data.cacheBible',
                        // text: primaryScripture.info.description,
                        text: bible.result.info.description,
                        // text: 'orange {{description}}',
                        semanticsLabel: 'description',
                      ),
                    ],
                  ),
                ),
                duration: const Duration(milliseconds: 400),
                onAwait: const ViewFeedbacks.await(),
                child: ViewLists(
                  // physics: const NeverScrollableScrollPhysics(),
                  duration: const Duration(milliseconds: 400),
                  itemBuilder: (BuildContext _, int index) {
                    return _inheritedVerse(primaryVerse.elementAt(index));
                  },
                  itemSnap: const VerseItemSnap(),
                  itemCount: primaryVerse.length,
                ),
                // child: ViewLists(
                //   // physics: const NeverScrollableScrollPhysics(),
                //   duration: const Duration(milliseconds: 400),
                //   itemBuilder: (BuildContext _, int index) {
                //     return _inheritedVerse(primaryVerse.elementAt(index));
                //   },
                //   itemSnap: const VerseItemSnap(),
                //   itemCount: primaryVerse.length,
                // ),
              );
            },
          );
        },
      ),
    ];
  }

  // Widget _inheritedVerse(OfVerse verse) {
  //   return ValueListenableBuilder<List<int>>(
  //     key: verse.key,
  //     valueListenable: primaryScripture.data.verseSelection,
  //     builder: (context, value, _) {
  //       return marks(verse, value);
  //       // return VerseWidgetInherited(
  //       //   size: data.boxOfSettings.fontSize().asDouble,
  //       //   lang: primaryScripture.info.langCode,
  //       //   selected: value.indexWhere((id) => id == verse.id) >= 0,
  //       //   marks: primaryScripture.marks,
  //       //   child: VerseItemWidget(
  //       //     verse: verse.updateName(primaryScripture.digit(verse.id)),
  //       //     onPressed: (int id) {
  //       //       // primaryScripture.digit(verse.id);
  //       //       int index = value.indexWhere((i) => i == id);
  //       //       if (index >= 0) {
  //       //         // value.removeAt(index);
  //       //         primaryScripture.verseSelection.value = List.from(value)..removeAt(index);
  //       //       } else {
  //       //         // value.add(id);
  //       //         primaryScripture.verseSelection.value = List.from(value)..add(id);
  //       //       }
  //       //       // primaryScripture.count.value = List.from(value)..add(...);
  //       //       // primaryScripture.count = value;
  //       //     },
  //       //   ),
  //       // );
  //     },
  //   );

  //   // return AnimatedBuilder(
  //   //   animation: Listenable.merge([primaryScripture.verseSelection, primaryScripture.verseColor]),
  //   //   builder: (BuildContext context, _) {
  //   //     final select = primaryScripture.verseSelection.value;
  //   //     final color = primaryScripture.verseColor.value;
  //   //     return VerseWidgetInherited(
  //   //       size: data.boxOfSettings.fontSize().asDouble,
  //   //       lang: primaryScripture.info.langCode,
  //   //       selected: select.indexWhere((id) => id == verse.id) >= 0,
  //   //       child: VerseItemWidget(
  //   //         verse: verse.updateName(primaryScripture.digit(verse.id)),
  //   //         onPressed: (int id) {
  //   //           // primaryScripture.digit(verse.id);
  //   //           int index = select.indexWhere((i) => i == id);
  //   //           if (index >= 0) {
  //   //             // value.removeAt(index);
  //   //             primaryScripture.verseSelection.value = List.from(select)..removeAt(index);
  //   //           } else {
  //   //             // value.add(id);
  //   //             primaryScripture.verseSelection.value = List.from(select)..add(id);
  //   //           }
  //   //           // primaryScripture.count.value = List.from(value)..add(...);
  //   //           // primaryScripture.count = value;
  //   //         },
  //   //       ),
  //   //     );
  //   //   },
  //   // );
  // }

  Widget _inheritedVerse(OfVerse verse) {
    return ListenableBuilder(
      key: verse.key,
      listenable: primaryScripture.marks,
      builder: (BuildContext context, Widget? child) {
        return VerseWidgetInherited(
          size: data.boxOfSettings.fontSize().asDouble,
          lang: primaryScripture.info.langCode,
          verseId: verse.id,
          marks: primaryScripture.marks,
          child: VerseItemWidget(
            verse: verse.updateName(primaryScripture.digit(verse.id)),
            onPressed: primaryScripture.marks.setSelection,
          ),
        );
      },
    );
  }
}

// class PullToRefresh extends PullToActivate {
//   const PullToRefresh({Key? key}) : super(key: key);

//   @override
//   State<PullToActivate> createState() => _PullToRefreshState();
// }

// class _PullToRefreshState extends PullOfState {
//   // late final Core core = context.read<Core>();
//   @override
//   Future<void> refreshUpdate() async {
//     await Future.delayed(const Duration(milliseconds: 50));
//     // await core.updateBookMeta();
//     // await Future.delayed(const Duration(milliseconds: 100));
//     // await core.collection.updateToken();
//     // await Future.delayed(const Duration(milliseconds: 400));
//   }
// }
