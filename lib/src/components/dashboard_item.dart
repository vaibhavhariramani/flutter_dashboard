part of './components.dart';

class FlutterDashboardItem {
  final String title;
  final Widget icon;
  final GetPage? page;
  final Widget? selectedIcon;
  final void Function(String? value)? search;
  final AppBarOptions? appBarOptions;
  final List<FlutterDashboardItem> subItems;
  final List<Widget> actions;
  final bool overrideActions;

  FlutterDashboardItem({
    required this.title,
    required this.icon,
    required this.page,
    this.appBarOptions,
    this.selectedIcon,
    this.search,
    this.overrideActions = false,
    this.actions = const [],
  }) : subItems = [];

  FlutterDashboardItem.items({
    required this.title,
    required this.icon,
    required this.subItems,
  })  : selectedIcon = null,
        appBarOptions = null,
        search = null,
        overrideActions = false,
        actions = const [],
        page = null;
}
