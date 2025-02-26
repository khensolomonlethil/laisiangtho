import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Views(
        child: ValueListenableBuilder(
          valueListenable: boxOfBooks.listen(),
          builder: (BuildContext _, Box<BooksType> e, Widget? ___) {
            items = e;

            return ChangeNotifierProvider.value(
              value: iso,
              child: Consumer<ISOFilter>(
                builder: (context, value, child) {
                  return CustomScrollView(
                    controller: scrollController,
                    slivers: _slivers,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      AppBarSliver.adaptive(
        children: [
          AdaptiveAppBar(
            height: const [kToolbarHeight, kToolbarHeight],
            builder: _headerMobile,
          ),
        ],
      ),

      const PullToRefresh(),
      // bookList(),
      // TODO: To be improved (too slow rendering)
      ViewSections(
        sliver: true,
        child: ViewDelays.milliseconds(
          sliver: false,
          onAwait: const ViewFeedbacks.await(sliver: false),
          builder: (_, __) => bookList(),
        ),
      ),

      ViewFlats(
        sliver: true,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        child: Paragraphs(
          text: preference.text('totalBookLang'),
          style: style.bodySmall,
          textAlign: TextAlign.center,
          decoration: [
            TextSpan(
              text: preference.digit(context, items.length),
              semanticsLabel: 'totalBook',
              style: TextStyle(
                color: theme.highlightColor,
              ),
            ),
            TextSpan(
              text: preference.digit(context, iso.all.length),
              semanticsLabel: 'totalLanguage',
              style: TextStyle(
                color: theme.highlightColor,
              ),
            ),
          ],
        ),
      ),

      ViewFlats(
        sliver: true,
        show: items.length < 57,
        padding: const EdgeInsets.only(bottom: 30),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: updateProgress,
            builder: (_, update, child) {
              if (update) {
                return child!;
              }
              return BookUpdateAvailable(
                onPress: () {
                  updateProgress.value = true;
                  app.updateBookMeta().whenComplete(() {
                    updateProgress.value = false;
                  });
                },
              );
            },
            child: const BookUpdateAvailable(),
          ),
        ),
      ),
    ];
  }

  Widget bookList() {
    return ViewLists.reorderable(
      key: const ValueKey('reorderable'),
      sliver: false,
      duration: const Duration(milliseconds: 400),
      itemSnap: const BookListItemSnap(),
      itemPrototype: const BookListItemSnap(),
      buildDefaultDragHandles: false,
      itemBuilder: (BuildContext context, int index) {
        final item = items.values.elementAt(index);

        final show = iso.all
            .firstWhere(
              (e) => e.code == item.langCode,
              orElse: () => iso.all.first,
            )
            .show;

        if (show) {
          return bookContainer(index, item);
        }
        // return const SizedBox();
        return const BookListItemSnap();
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return AnimatedOpacity(
              opacity: 0.9,
              duration: const Duration(milliseconds: 500),
              child: child,
            );
          },
          child: child,
        );
      },
      itemCount: items.length,
      reorderable: boxOfBooks.reorderable,
    );
  }

  Widget bookContainer(int index, BooksType book) {
    return ViewSwipeWidget(
      // key: ValueKey(item),
      menu: [
        ViewButtons(
          message: lang.more,
          onPressed: () => showBibleInfo(book),
          child: const ViewLabels(
            icon: LideaIcon.dotHoriz,
          ),
        ),
      ],
      child: ViewCards(
        sliver: false,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: bookDecoration(index, book),
      ),
    );
  }

  Widget bookDecoration(int index, BooksType book) {
    return Stack(
      children: [
        if (book.selected) const BookListItemCorner(),
        BookListItem(
          book: book,
          index: index,
          onPress: () => showBibleContent(book, index),
          dragController: _dragController,
        ),
      ],
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BookListItemCorner extends StatelessWidget {
  const BookListItemCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -13,
      right: 0,
      child: ClipPath(
        clipper: CustomTriangleClipper(),
        child: Container(
          // width: 60,
          // height: 50,
          width: 50,
          height: 50,
          alignment: const Alignment(.9, .1),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     // theme.highlightColor,
            //     theme.primaryColor,
            //     theme.disabledColor,
            //     // Color(0xffF25D50),
            //     // Color(0xffF2BB77),
            //   ],
            // ),
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
    );
  }
}

class PullToRefresh extends ViewPulls {
  const PullToRefresh({super.key});

  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    await App.core.updateBookMeta();
    await Future.delayed(const Duration(milliseconds: 100));
    // await App.core.data.updateToken();
    // await Future.delayed(const Duration(milliseconds: 200));
  }
}

// BookItemSnap BookListItem
class BookListItemSnap extends StatelessWidget {
  const BookListItemSnap({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewCards(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 20,
                // width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 15,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Container(
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// BookUpdateAvailable
class BookUpdateAvailable extends StatelessWidget {
  const BookUpdateAvailable({super.key, this.onPress});

  final void Function()? onPress;

  bool get update => onPress == null;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        backgroundColor: context.theme.dividerColor,
        elevation: 30,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        disabledBackgroundColor: context.theme.disabledColor,
        // iconColor: theme.hintColor,
      ),
      onPressed: onPress,
      // onPressed: update ? null : App.core.updateBookMeta,
      // icon: const Icon(Icons.tips_and_updates),

      icon: update
          ? SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.theme.colorScheme.error,
              ),
            )
          : const Icon(
              Icons.tips_and_updates,
              size: 25,
            ),
      label: Text(
        context.lang.updateTo(context.lang.available('').toLowerCase()),
        semanticsLabel: 'Update',
        style: context.style.labelLarge,
      ),
    );
  }
}
