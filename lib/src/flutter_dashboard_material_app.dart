import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';

class FlutterDashboardMaterialApp<T> extends StatefulWidget {
  final String title;
  final DashboardConfig config;
  final List<FlutterDashboardItem> dashboardItems;
  final DrawerOptions drawerOptions;
  final AppBarOptions appBarOptions;
  final List<T>? rootControllers;
  final List<Widget> overrideActions;
  final List<GetPage> rootPages;
  final List<NavigatorObserver>? navigatorObservers;
  final Widget Function(BuildContext, Widget?)? builder;
  final List<GetMiddleware>? dashboardMiddlewares;
  final Widget notFoundPage;
  final Widget Function(
    BuildContext context,
    GetDelegate delegate,
    GetNavConfig? currentRoute,
  )? overrideRootPage;

  FlutterDashboardMaterialApp({
    Key? key,
    required this.title,
    this.rootControllers,
    this.overrideActions = const [],
    this.rootPages = const [],
    this.navigatorObservers,
    this.builder,
    required this.dashboardItems,
    this.appBarOptions = const AppBarOptions(),
    this.config = const DashboardConfig(),
    this.drawerOptions = const DrawerOptions(),
    this.dashboardMiddlewares,
    this.overrideRootPage,
    this.notFoundPage = const Scaffold(
      body: Center(
        child: Text(
          '404 Page Not Found.',
        ),
      ),
    ),
  })  : assert(
          dashboardItems.isNotEmpty,
        ),
        super(key: key);

  @override
  State<FlutterDashboardMaterialApp<T>> createState() =>
      _FlutterDashboardMaterialAppState<T>();

  static FlutterDashboardMaterialApp of(BuildContext context) => context
      .findAncestorStateOfType<_FlutterDashboardMaterialAppState>()!
      .widget;
}

class _FlutterDashboardMaterialAppState<T>
    extends State<FlutterDashboardMaterialApp<T>> {
  @override
  void initState() {
    DashboardPages.setRootPages(widget.rootPages);
    DashboardPages.genarateRoutes(
      widget.dashboardItems,
      widget.drawerOptions.footerNavItems,
      widget.dashboardMiddlewares,
      widget.overrideRootPage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: widget.config.debugShowCheckedModeBanner,
      title: widget.title,
      getPages: DashboardPages.routes,
      scaffoldMessengerKey: Get.rootController.scaffoldMessengerKey,
      popGesture: Get.isPopGestureEnable,
      transitionDuration: Get.defaultTransitionDuration,
      defaultTransition: Transition.leftToRightWithFade,
      customTransition: Get.customTransition,
      theme: widget.config.theme,
      darkTheme: widget.config.darkTheme,
      themeMode: widget.config.themeMode,
      locale: widget.config.locale ?? Get.deviceLocale,
      localizationsDelegates: widget.config.localizationsDelegates,
      localeListResolutionCallback: widget.config.localeListResolutionCallback,
      localeResolutionCallback: widget.config.localeResolutionCallback,
      fallbackLocale: widget.config.fallbackLocale ?? Get.fallbackLocale,
      supportedLocales: widget.config.supportedLocales,
      textDirection: widget.config.textDirection,
      translations: widget.config.translations,
      translationsKeys: widget.config.translations?.keys ?? Get.translations,
      builder: widget.builder,
      navigatorObservers: widget.navigatorObservers,
      unknownRoute: DashboardPages.unknownPage,
      initialBinding: BindingsBuilder(
        () {
          Get.put(
              FlutterDashboardNavService(
                navItems: widget.dashboardItems,
                navFooterItems: widget.drawerOptions.footerNavItems,
              ),
              permanent: true);
          if ((widget.rootControllers ?? []).isNotEmpty) {
            for (var _controller in (widget.rootControllers ?? [])) {
              _controller;
            }
          }
        },
      ),
    );
  }
}
