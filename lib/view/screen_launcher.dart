import 'package:flutter/material.dart';

/// NOTE: SystemUiOverlayStyle
import 'package:flutter/services.dart';

/// NOTE: Core, Components
import '/app.dart';

part 'screen_splash.dart';
part 'bottom_navigation.dart';

class ScreenLauncher extends StatefulWidget {
  final RouteDelegates delegate;
  const ScreenLauncher({super.key, required this.delegate});

  @override
  State<ScreenLauncher> createState() => _ScreenLauncherState();
}

class _ScreenLauncherState extends StateAbstract<ScreenLauncher> {
  late final _session = widget.delegate.notifier;
  late final PageController pageController = PageController(initialPage: _session.viewIndex);
  // late final Future<void> _initiator = Future.delayed(const Duration(milliseconds: 300));
  late final Future<void> _initiator = app.initialized(context);

  // @override
  // void initState() {
  //   super.initState();
  //   // App.scroll.state = OfContexts(context);
  //   WidgetsBinding.instance.addPostFrameCallback(_mediaData);
  // }

  // Todo: might not needed
  void _mediaData(Duration timestamp) {
    // viewData.fromContext = MediaQuery.of(context);
  }

  // Deep link
  void onPageChange() {
    if (!pageController.hasClients) return;
    _session.setIndex();
    pageController.jumpToPage(_session.viewIndex);
    // if (_started) {
    //   pageController.jumpToPage(_session.viewIndex);
    // } else {
    //   pageController.animateToPage(
    //     _session.viewIndex,
    //     duration: const Duration(milliseconds: 700),
    //     curve: Curves.easeIn,
    //   );
    //   _started = true;
    // }

    // Future.microtask(() {
    //   final value = App.scroll.bottomFactor.value;

    //   final double a = 0.99.roundToDouble();
    //   final double b = 0.2.roundToDouble();
    //   debugPrint('bottomFactor: $value ($a, $b).roundToDouble');
    //   // App.scroll.bottomFactor.value = 1.0;
    // });
    // Future.delayed(
    //   const Duration(milliseconds: 700),
    //   () {
    //     App.scroll.bottomFactorAnimationTesting();
    //   },
    // );
    // Future.delayed(
    //   const Duration(milliseconds: 400),
    //   () {
    //     App.scroll.bottom.animationTesting();
    //   },
    // ).whenComplete(() {
    //   App.scroll.bottom.update();
    // });
    app.bottom.refresh();
    // Future.microtask(() {
    //   App.scroll.bottom.animationTesting();
    // }).whenComplete(() {
    //   App.scroll.bottom.update();
    // });
  }

  @override
  void didUpdateWidget(covariant ScreenLauncher oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.microtask(onPageChange);
  }

  @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initiator,
  //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.done:
  //           // return launched();
  //           return OrientationBuilder(
  //             builder: (context, orientation) {
  //               if (MediaQuery.of(context).orientation != App.scroll.context.orientation) {
  //                 _mediaData(const Duration(microseconds: 1));
  //               }
  //               return launched();
  //             },
  //           );
  //         default:
  //           return const ScreenSplash();
  //       }
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        // systemNavigationBarDividerColor: Colors.transparent,
        // systemNavigationBarDividerColor: Colors.red,
        systemNavigationBarIconBrightness: preference.resolvedSystemBrightness,
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        statusBarBrightness: preference.systemBrightness,
        statusBarIconBrightness: preference.resolvedSystemBrightness,
        systemStatusBarContrastEnforced: false,
      ),
      child: FutureBuilder(
        future: _initiator,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return OrientationBuilder(
                builder: (context, orientation) {
                  if (MediaQuery.of(context).orientation != state.fromContext.orientation) {
                    _mediaData(const Duration(microseconds: 1));
                  }
                  return launched();
                },
              );
            // return const ScreenSplash();
            default:
              return const ScreenSplash();
          }
        },
      ),
    );
  }

  Widget launched() {
    // return Scaffold(
    //   key: const Key('ScreenLauncher'),
    //   primary: true,
    //   body: SafeArea(
    //     top: false,
    //     bottom: false,
    //     maintainBottomViewPadding: true,
    //     child: PageView(
    //       key: const Key('ScreenLauncherPageView'),
    //       controller: pageController,
    //       physics: const NeverScrollableScrollPhysics(),
    //       children: _viewChildren,
    //     ),
    //   ),
    //   extendBody: true,
    //   // resizeToAvoidBottomInset: true,
    //   bottomNavigationBar: const BottomNavigationBarWidget(),
    // );

    return SafeArea(
      top: false,
      bottom: false,
      // left: false,
      // right: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        key: const Key('ScreenLauncher'),
        primary: true,
        // extendBody: true,
        extendBodyBehindAppBar: true,

        body: PageView(
          key: const Key('ScreenLauncherPageView'),
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _viewChildren,
        ),
        // extendBody: true,
        // resizeToAvoidBottomInset: true,
        bottomNavigationBar: const BottomNavigationWidget(),
      ),
    );
  }

  late final List<Widget> _viewChildren = List.of(
    _session.routesPrimary.map(
      (route) => ViewKeepAlive(
        key: Key('ScreenLauncherViewKeepAlive-${route.name}'),
        child: NestedView(
          delegate: NestedDelegates(
            bridge: _session,
            name: route.name,
            route: route.nest,
          ),
        ),
      ),
    ),
  );
}
