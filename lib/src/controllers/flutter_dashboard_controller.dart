part of './controllers.dart';

class FlutterDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static FlutterDashboardController get to =>
      Get.find<FlutterDashboardController>();

  final FlutterDashboardNavService _navService = FlutterDashboardNavService.to;

  GetDelegate? delegate;

  final RxString currentRoute = ''.obs, currentPageTitle = ''.obs;

  final RxBool isScreenLoading = false.obs, isDrawerOpen = false.obs;

  late AnimationController expansionController;
  late FocusNode focusNode;

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  String dashboardInitialRoute =
      "${DashboardRoutes.DASHBOARD}${FlutterDashboardMaterialApp.of(Get.context!).dashboardItems[0].page!.name}";

  final RxMap<String, FlutterDashboardItem> finalRoutes =
      RxMap<String, FlutterDashboardItem>();

  FlutterDashboardItem get selectedDrawerItem {
    if (finalRoutes.containsKey(currentPageTitle.value)) {
      return finalRoutes[currentPageTitle.value]!;
    } else {
      return _navService.rawRoutes.first;
    }
  }

  void _addRoutes(List<FlutterDashboardItem> _items) {
    for (var item in _items) {
      if (item.subItems.isEmpty) {
        finalRoutes[item.title] = item;
      } else {
        _addRoutes(item.subItems);
      }
    }
  }

  List<FlutterDashboardItem> expandItems(List<FlutterDashboardItem> items) {
    return items
        .expand((FlutterDashboardItem element) => element.subItems.isEmpty
            ? [element]
            : expandItems(element.subItems))
        .toList();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      // print(_navService.finalRoutes);
      _addRoutes(_navService.rawFooterRoutes);
      _addRoutes(_navService.finalRoutes);
    });

    isScreenLoading(true);

    focusNode = FocusNode();
    expansionController = AnimationController(
      vsync: this,
      duration: 250.milliseconds,
      value: 1.0,
    );

    ever(currentRoute, (String location) {
      String _location = location.split('/').last.toLowerCase();

      if (_location.isEmpty || _location == 'dashboard') {
        currentPageTitle(_navService.rawRoutes.first.title);
      } else {
        // print(_location);
        // print(finalRoutes);
        // print(finalRoutes);
        // print(finalRoutes.entries.map((element) =>
        //     _location == element.value.page?.name.split('/').last));

        // print(finalRoutes.values.where((FlutterDashboardItem element) =>
        //     _location.contains('${element.page?.name.split('/').last}')));

        WidgetsBinding.instance.addPersistentFrameCallback((_) {
          if (finalRoutes.values
              .where((FlutterDashboardItem element) =>
                  _location.contains('${element.page?.name.split('/').last}'))
              .isNotEmpty) {
            // if (finalRoutes.entries
            //     .where((element) =>
            //         _location == element.value.page?.name.split('/').last)
            //     .isNotEmpty) {
            //   currentPageTitle(finalRoutes.entries
            //       .singleWhere((element) =>
            //           _location == element.value.page?.name.split('/').last)
            //       .key);
            // } else {
            //   currentPageTitle("404");
            //   delegate?.toNamed(DashboardRoutes.ERROR404);
            // }
            currentPageTitle(finalRoutes.values
                .singleWhere((FlutterDashboardItem element) =>
                    _location.contains('${element.page?.name.split('/').last}'))
                .title);
          } else {
            currentPageTitle("404");
            delegate?.toNamed(DashboardRoutes.ERROR404);
          }
        });

        // Get.log('Current dashboard route : ${currentPageTitle.value}');
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    isScreenLoading(false);
    super.onReady();
  }

  @override
  void onClose() {
    focusNode.dispose();
    expansionController.dispose();
    super.onClose();
  }
}
