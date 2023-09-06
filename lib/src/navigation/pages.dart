part of './flutter_dashboard_navigation.dart';

class DashboardPages {
  DashboardPages._();

  static String get InitialRoute => DashboardRoutes.DASHBOARD;

  static final List<GetPage> _rootPages = [];
  static final List<GetPage> _routes = [];

  static List<GetPage> get routes => _routes;

  static List<GetPage> _pages(FlutterDashboardItem e) {
    if (e.page != null) {
      return [e.page!];
    } else {
      return e.subItems
          .map((e) => _pages(e))
          .expand((element) => element)
          .toList();
    }
  }

  static void setRootPages(List<GetPage> _pages) {
    _rootPages.addAll(_pages);
  }

  static GetPage unknownPage = GetPage(
    name: _Paths.ERROR404,
    page: () => const Scaffold(
      body: Center(
        child: Text('Not found'),
      ),
    ),
  );

  static void genarateRoutes(
    List<FlutterDashboardItem> dashboardItems,
    List<FlutterDashboardItem> footerItems,
    List<GetMiddleware>? dashboardMiddlewares,
    Widget Function(
      BuildContext context,
      GetDelegate delegate,
      GetNavConfig? currentRoute,
    )?
        overrideRootPage,
  ) {
    final List<GetPage> _allPages = [
      for (var item in dashboardItems) ..._pages(item),
    ];
    final List<GetPage> _allFooterPages = [
      for (var item in footerItems) ..._pages(item),
    ];

    _routes.addAll(
      [
        GetPage(
          participatesInRootNavigator: true,
          preventDuplicates: true,
          name: '/',
          page: () => GetRouterOutlet.builder(
            builder: overrideRootPage ??
                (BuildContext context, GetDelegate delegate,
                    GetNavConfig? current) {
                  return GetRouterOutlet(
                    initialRoute: DashboardRoutes.DASHBOARD,
                    delegate: GetDelegate(
                      notFoundRoute: unknownPage,
                    ),
                  );
                },
          ),
          unknownRoute: unknownPage,
          children: [
            // GetPage(
            //   preventDuplicates: true,
            //   name: _Paths.LOGIN,
            //   page: () => LoginView(),
            //   binding: BindingsBuilder(
            //     () {
            //       Get.lazyPut<LoginController>(() => LoginController());
            //     },
            //   ),
            //   middlewares: [
            //     FlutterDashboardEnsureNotAuthenticated(),
            //   ],
            // ),
            ..._rootPages,
            GetPage(
              preventDuplicates: true,
              name: _Paths.DASHBOARD,
              page: () => FlutterDashboardRootView(),
              binding: BindingsBuilder(() {
                Get.lazyPut<FlutterDashboardController>(
                  () => FlutterDashboardController(),
                );
              }),
              title: null,
              transition: Transition.fadeIn,
              children: [
                ..._allPages,
                ..._allFooterPages,
              ],
              middlewares: dashboardMiddlewares,
            ),
          ],
        ),
      ],
    );
  }
}
