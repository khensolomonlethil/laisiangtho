import 'package:flutter/material.dart';

import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'leaf-editor';
  static String label = 'Editor';
  static IconData icon = Icons.edit;

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  // Scripture get scripture => App.core.scripturePrimary;
  // CacheTitle get title => scripture.title;

  late final _formKey = GlobalKey<FormState>();
  late final _textController = TextEditingController();
  late final _focusNode = FocusNode();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _controller.dispose();
  // }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _textController.text = state.asMap['text'];
      if (_focusNode.canRequestFocus && autoFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  bool get autoFocus {
    return args.isNotEmpty && args['focus'] != null;
  }

  String get pageTitle {
    // return args.isNotEmpty && args['title'] != null;
    if (args.isNotEmpty) {
      if (args['pageTitle'] != null) {
        return args['pageTitle'];
      }
    }
    return '...';
  }

  String get pageLabel {
    // return args.isNotEmpty && args['title'] != null;
    if (args.isNotEmpty) {
      if (args['pageLabel'] != null) {
        return args['pageLabel'];
      }
    }
    return App.preference.text.text('true');
  }

  void onSubmit(String str) {
    Navigator.of(context, rootNavigator: true).maybePop({'text': str});
  }
}

mixin _Header on _State {
  Widget backOrHome() {
    final parent = Navigator.of(context, rootNavigator: true);
    final self = Navigator.of(context);

    final selfCanPop = self.canPop();
    // return OptionButtons(
    //   navigator: selfCanPop ? self : parent,
    //   label: selfCanPop ? App.preference.text.back : App.preference.text.cancel,
    //   type: selfCanPop ? 'back' : 'cancel',
    // );
    if (selfCanPop) {
      return OptionButtons.back(
        navigator: self,
        label: App.preference.text.back,
      );
    }
    return OptionButtons.cancel(
      navigator: parent,
      label: App.preference.text.cancel,
    );
  }

  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kTextTabBarHeight,
      left: [
        backOrHome(),
      ],
      primary: ViewHeaderTitle.dual(
        label: pageLabel,
        // header: '....',
        // header: title.result.book.first.info.name,
        // header: itemBooks.first.info.name,
        // header: title.result.book.first.info.name,
        header: pageTitle,
        // header: title.result.book.first.info.name,
        shrinkMax: 16,
      ),
      // right: [
      //   OptionButtons.icon(
      //     onPressed: () {},
      //     icon: Icons.check,
      //   ),
      // ],
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: true,
      resizeToAvoidBottomInset: false,
      appBar: ViewBars(
        height: kTextTabBarHeight,
        // forceOverlaps: false,
        forceStretch: true,
        backgroundColor: Theme.of(context).primaryColor,
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        child: _header(),
      ),
      body: Views(
        heroController: HeroController(),
        child: editor,
      ),
    );
  }

  Widget get editor {
    // return ConstrainedBox(
    //   constraints: const BoxConstraints(
    //     maxHeight: 300.0,
    //   ),
    //   child: const Scrollbar(
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.vertical,
    //       reverse: true,
    //       child: Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: TextField(
    //           maxLines: null,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // return Scrollbar(
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     reverse: true,
    //     child: field(),
    //   ),
    // );
    // return const TextField(
    //   maxLines: null,
    // );
    return field();
  }

  Widget field() {
    // TextField(
    //   maxLines: null,
    // );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: _formKey,
        controller: _textController,
        focusNode: _focusNode,
        // initialValue: state.asMap['text'],
        minLines: 3,
        maxLines: 7,
        // cursorHeight: 20,
        // expands: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          hintText: ' . . .',
          contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
          fillColor: Theme.of(context).primaryColor,
        ),
        onFieldSubmitted: onSubmit,
      ),
    );
  }
}
