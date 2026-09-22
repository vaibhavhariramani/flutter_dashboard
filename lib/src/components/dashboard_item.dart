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

  /// An optional widget shown at the end of this item's drawer entry, e.g. a
  /// notification-count badge or a "new" chip. Ignored on items created via
  /// [FlutterDashboardItem.items] (parent entries use their expand arrow).
  final Widget? trailing;

  FlutterDashboardItem({
    required this.title,
    required this.icon,
    required this.page,
    this.appBarOptions,
    this.selectedIcon,
    this.search,
    this.overrideActions = false,
    this.actions = const [],
    this.trailing,
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
        trailing = null,
        page = null;
}
