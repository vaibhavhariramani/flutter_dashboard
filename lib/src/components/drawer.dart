part of './components.dart';

class DrawerOptions {
  final Color? backgroundColor;
  final DecorationImage? image;
  final Gradient? gradient;
  final List<Widget> headers;
  final Widget? footer;
  final Widget? logo;
  final Widget? closeIcon;
  final bool showCloseButton;
  final Color? selectedItemColor;
  final Color? unSelectedItemColor;
  final Color? selectedTextColor;
  final bool centerHeaderLogo;
  final double? listSpacing;
  final EdgeInsetsGeometry tilePadding;
  final EdgeInsetsGeometry? tileContentPadding;
  final ShapeBorder? tileShape;
  final DrawerSliverPersistentHeaderDelegate? overrideHeader;
  final List<FlutterDashboardItem> footerNavItems;

  const DrawerOptions({
    this.headers = const [],
    this.footer,
    this.backgroundColor,
    this.image,
    this.gradient,
    this.logo,
    this.showCloseButton = true,
    this.closeIcon,
    this.selectedItemColor,
    this.unSelectedItemColor,
    this.selectedTextColor,
    this.centerHeaderLogo = false,
    this.listSpacing,
    this.tilePadding = EdgeInsets.zero,
    this.tileContentPadding,
    this.tileShape,
    this.overrideHeader,
    this.footerNavItems = const [],
  });
}

typedef DrawerSliverPersistentHeaderDelegate = SliverPersistentHeaderDelegate;

class _DrawerIcon extends GetResponsiveView<FlutterDashboardController> {
  _DrawerIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    bool hasDrawer = controller.drawerKey.currentState?.hasDrawer == true;

    return Obx(
      () => IconButton(
        onPressed: () {
          if (FlutterDashboardMaterialApp.of(context)
                  .drawerOptions
                  .overrideHeader ==
              null) {
            if (hasDrawer) {
              if (!controller.isDrawerOpen.value) {
                controller.drawerKey.currentState?.openDrawer();
              } else {
                Navigator.of(context).pop();
              }
            } else {
              if (controller.expansionController.value == 0 ||
                  controller.expansionController.value == 1) {
                if (controller.expansionController.value == 0) {
                  controller.expansionController.animateTo(1.0);
                } else {
                  controller.expansionController.animateTo(0.0);
                }
              }
            }
          } else {
            if (hasDrawer) {
              var isDrawerOpen = Scaffold.of(screen.context).isDrawerOpen;
              if (!isDrawerOpen) {
                controller.drawerKey.currentState?.openDrawer();
              } else {
                Navigator.of(context).pop();
              }
            }
          }
        },
        padding: EdgeInsets.zero,
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: Tween(
                  begin: controller.isDrawerOpen.value ? 1.0 : 0.0,
                  end: controller.isDrawerOpen.value ? 0.0 : 1.0)
              .animate(controller.expansionController),
        ),
      ),
    );
  }
}

abstract class FlutterDashboardDrawerHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  double? height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return build(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent =>
      height ?? (kToolbarHeight + Get.mediaQuery.padding.bottom);

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

mixin DrawerHeaderMixin {
  double? height;
  Widget? drawerIcon;
  Widget? brandLogo;
}

class _DrawerHeader extends FlutterDashboardDrawerHeaderDelegate {
  final ResponsiveScreen screen;
  final Widget? logo;
  final Widget? drawerIcon;

  _DrawerHeader({
    required this.screen,
    required this.logo,
    required this.drawerIcon,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    DrawerOptions _dashboardDrawerOptions =
        FlutterDashboardMaterialApp.of(screen.context).drawerOptions;

    return DrawerHeader(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment:
            screen.isDesktop && _dashboardDrawerOptions.centerHeaderLogo
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.rootDelegate
                  .toNamed(FlutterDashboardController.to.dashboardInitialRoute);
            },
            child: Align(
              alignment:
                  screen.isDesktop && _dashboardDrawerOptions.centerHeaderLogo
                      ? AlignmentDirectional.center
                      : AlignmentDirectional.centerStart,
              child: logo ??
                  FlutterLogo(
                    textColor: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          drawerIcon ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _FlutterDashboardDrawer
    extends GetResponsiveView<FlutterDashboardController> {
  final Widget? drawerIcon;
  final AnimationController expansiocController;
  _FlutterDashboardDrawer({
    Key? key,
    required this.drawerIcon,
    required this.expansiocController,
  }) : super(key: key);

  FlutterDashboardMaterialApp get _dashboard =>
      FlutterDashboardMaterialApp.of(screen.context);

  DrawerOptions get _dashboardDrawer => _dashboard.drawerOptions;

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _dashboardDrawer.backgroundColor,
        image: _dashboardDrawer.image,
        gradient: _dashboardDrawer.gradient,
      ),
      child: Material(
        elevation: _dashboard.config.theme != null ||
                _dashboard.config.darkTheme != null
            ? Get.theme.drawerTheme.elevation ??
                Theme.of(context).drawerTheme.elevation ??
                (Get.isDarkMode
                    ? _dashboard.config.darkTheme?.drawerTheme.elevation
                    : _dashboard.config.theme?.drawerTheme.elevation) ??
                kDefaultElevation
            : kDefaultElevation,
        shape: _dashboard.config.enableSpacing
            ? screen.isDesktop
                ? Theme.of(context).drawerTheme.shape ??
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                      _dashboard.config.radius,
                    ))
                : const RoundedRectangleBorder()
            : const RoundedRectangleBorder(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).drawerTheme.backgroundColor,
        child: Drawer(
          elevation: _dashboard.config.theme != null ||
                  _dashboard.config.darkTheme != null
              ? Get.theme.drawerTheme.elevation ??
                  Theme.of(context).drawerTheme.elevation ??
                  (Get.isDarkMode
                      ? _dashboard.config.darkTheme?.drawerTheme.elevation
                      : _dashboard.config.theme?.drawerTheme.elevation) ??
                  kDefaultElevation
              : kDefaultElevation,
          shape: _dashboard.config.enableSpacing
              ? screen.isDesktop
                  ? Theme.of(context).drawerTheme.shape
                  : const RoundedRectangleBorder()
              : const RoundedRectangleBorder(),
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: CustomScrollView(
            controller: ScrollController(),
            clipBehavior: Clip.hardEdge,
            slivers: [
              SliverPersistentHeader(
                delegate: _dashboard.drawerOptions.overrideHeader ??
                    _DrawerHeader(
                      logo:
                          _dashboard.config.brandLogo ?? _dashboardDrawer.logo,
                      drawerIcon: !screen.isDesktop ? drawerIcon : null,
                      screen: screen,
                    ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  color: Colors.transparent,
                  height: _dashboardDrawer.listSpacing ?? 0,
                ),
              ),
              _DrawerList(
                finalRoutes: FlutterDashboardNavService.to.finalRoutes,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (_dashboardDrawer.footerNavItems.isNotEmpty)
                        _FooterNavList(),
                      if (_dashboardDrawer.footerNavItems.isNotEmpty)
                        const Divider(
                          color: Colors.transparent,
                        ),
                      if (_dashboardDrawer.footer != null)
                        _dashboardDrawer.footer ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterNavList extends GetResponsiveView<FlutterDashboardController> {
  _FooterNavList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    FlutterDashboardMaterialApp _dashboard =
        FlutterDashboardMaterialApp.of(screen.context);

    FlutterDashboardItem selectedItem = controller.selectedDrawerItem;

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _dashboard.drawerOptions.footerNavItems
            .map(
              (item) => Padding(
                padding: _dashboard.drawerOptions.tilePadding,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: Theme.of(screen.context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: _dashboard
                                      .drawerOptions.selectedTextColor ??
                                  (item == selectedItem
                                      ? Get.isDarkMode
                                          ? Theme.of(screen.context)
                                              .textTheme
                                              .labelLarge
                                              ?.color
                                          : Theme.of(screen.context)
                                              .scaffoldBackgroundColor
                                      : Theme.of(screen.context).disabledColor))
                          .color,
                    ),
                    listTileTheme: ListTileThemeData(
                      horizontalTitleGap: 0.0,
                      shape: _dashboard.drawerOptions.tileShape,
                      tileColor: item == selectedItem
                          ? (_dashboard.drawerOptions.selectedItemColor ??
                              Theme.of(screen.context)
                                  .drawerTheme
                                  .backgroundColor)
                          : ((_dashboard.drawerOptions.unSelectedItemColor ==
                                      Colors.transparent
                                  ? Theme.of(screen.context)
                                      .drawerTheme
                                      .backgroundColor
                                  : _dashboard
                                      .drawerOptions.unSelectedItemColor) ??
                              Theme.of(screen.context)
                                  .drawerTheme
                                  .backgroundColor),
                      selectedColor: item == selectedItem
                          ? (Theme.of(screen.context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: _dashboard.drawerOptions
                                              .selectedTextColor ??
                                          (item == selectedItem
                                              ? Get.isDarkMode
                                                  ? Theme.of(screen.context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.color
                                                  : Theme.of(screen.context)
                                                      .scaffoldBackgroundColor
                                              : Theme.of(screen.context)
                                                  .disabledColor))
                                  .color ??
                              Theme.of(screen.context).primaryColor)
                          : (_dashboard.drawerOptions.unSelectedItemColor ??
                              Theme.of(screen.context)
                                  .listTileTheme
                                  .selectedColor),
                      selectedTileColor: item == selectedItem
                          ? (_dashboard.drawerOptions.selectedItemColor ??
                              Theme.of(screen.context).primaryColor)
                          : (_dashboard.drawerOptions.unSelectedItemColor ??
                              Theme.of(screen.context)
                                  .listTileTheme
                                  .selectedTileColor),
                      textColor: Theme.of(screen.context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: _dashboard
                                      .drawerOptions.selectedTextColor ??
                                  (item == selectedItem
                                      ? Get.isDarkMode
                                          ? Theme.of(screen.context)
                                              .textTheme
                                              .labelLarge
                                              ?.color
                                          : Theme.of(screen.context)
                                              .indicatorColor
                                      : Theme.of(screen.context).disabledColor))
                          .color,
                      iconColor: Theme.of(screen.context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: _dashboard
                                      .drawerOptions.selectedTextColor ??
                                  (item == selectedItem
                                      ? Get.isDarkMode
                                          ? Theme.of(screen.context)
                                              .textTheme
                                              .labelLarge
                                              ?.color
                                          : Theme.of(screen.context)
                                              .indicatorColor
                                      : Theme.of(screen.context).disabledColor))
                          .color,
                    ),
                    dividerColor: Colors.transparent,
                    shadowColor: _dashboard.appBarOptions.theme?.shadowColor ??
                        Theme.of(screen.context).shadowColor,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: item == selectedItem
                          ? Border.all(
                              color: Theme.of(screen.context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          color: _dashboard.drawerOptions
                                                  .selectedTextColor ??
                                              (item == selectedItem
                                                  ? Get.isDarkMode
                                                      ? Theme.of(screen.context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.color
                                                      : Theme.of(screen.context)
                                                          .indicatorColor
                                                  : Theme.of(screen.context)
                                                      .disabledColor))
                                      .color ??
                                  Colors.transparent,
                            )
                          : null,
                      borderRadius: item == selectedItem
                          ? BorderRadius.all(
                              _dashboard.drawerOptions.tileShape == null
                                  ? Radius.zero
                                  : const Radius.circular(kDefaultRadius),
                            )
                          : BorderRadius.zero,
                    ),
                    child: ListTile(
                      shape: _dashboard.drawerOptions.tileShape,
                      contentPadding:
                          _dashboard.drawerOptions.tileContentPadding,
                      onTap: () {
                        if (!screen.isDesktop) {
                          Navigator.of(screen.context).pop();
                        }
                        if (controller.selectedDrawerItem.title != item.title) {
                          FlutterDashboardController.to.delegate?.toNamed(
                            "${DashboardRoutes.DASHBOARD}${item.page!.name}",
                          );
                        }
                      },
                      leading: item.icon,
                      title: Text(
                        item.title,
                        textScaleFactor: Get.textScaleFactor,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }
}

class _DrawerList extends GetResponsiveView<FlutterDashboardController> {
  final List<FlutterDashboardItem> finalRoutes;
  _DrawerList({
    Key? key,
    required this.finalRoutes,
  }) : super(key: key);

  List<FlutterDashboardItem> _expanded(List<FlutterDashboardItem> items) {
    return items
        .expand((FlutterDashboardItem element) =>
            element.subItems.isEmpty ? [element] : _expanded(element.subItems))
        .toList();
  }

  FlutterDashboardMaterialApp get _dashboard =>
      FlutterDashboardMaterialApp.of(screen.context);

  @override
  Widget build(BuildContext context) {
    screen.context = context;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          if (FlutterDashboardMaterialApp.of(context)
              .drawerOptions
              .headers
              .isNotEmpty)
            ...FlutterDashboardMaterialApp.of(context)
                .drawerOptions
                .headers
                .map(
                  (e) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      e,
                      const Divider(
                        height: 50,
                      ),
                    ],
                  ),
                ),
          for (var _item in finalRoutes)
            Obx(
              () {
                return _buildList(
                  item: _item,
                  isFirstItem: finalRoutes.first.title == _item.title,
                  isLastSubItem: false,
                  selectedItem: controller.selectedDrawerItem,
                  expanded: _expanded(finalRoutes),
                  isSubItem: false,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildList({
    required FlutterDashboardItem item,
    required FlutterDashboardItem selectedItem,
    required bool isFirstItem,
    required List<FlutterDashboardItem> expanded,
    required bool isSubItem,
    required bool isLastSubItem,
  }) {
    return Padding(
      padding: isFirstItem
          ? EdgeInsets.only(
              top:
                  isSubItem ? _dashboard.drawerOptions.tilePadding.vertical : 0,
              left: _dashboard.drawerOptions.tilePadding.horizontal -
                  (isSubItem
                      ? (_dashboard.drawerOptions.tilePadding.horizontal)
                      : (_dashboard.drawerOptions.tilePadding.horizontal / 2)),
              right: _dashboard.drawerOptions.tilePadding.horizontal -
                  (isSubItem
                      ? (_dashboard.drawerOptions.tilePadding.horizontal)
                      : (_dashboard.drawerOptions.tilePadding.horizontal / 2)),
              bottom: isSubItem
                  ? _dashboard.drawerOptions.tilePadding.vertical
                  : _dashboard.drawerOptions.tilePadding.vertical -
                      (_dashboard.drawerOptions.tilePadding.vertical / 2),
            )
          : isSubItem
              ? EdgeInsets.only(
                  left: _dashboard.drawerOptions.tilePadding.horizontal -
                      (_dashboard.drawerOptions.tilePadding.horizontal),
                  right: _dashboard.drawerOptions.tilePadding.horizontal -
                      (_dashboard.drawerOptions.tilePadding.horizontal),
                  bottom: isLastSubItem
                      ? _dashboard.drawerOptions.tilePadding.vertical -
                          (_dashboard.drawerOptions.tilePadding.vertical / 1)
                      : _dashboard.drawerOptions.tilePadding.vertical,
                )
              : _dashboard.drawerOptions.tilePadding,
      child: Theme(
        data: Theme.of(screen.context).copyWith(
          iconTheme: IconThemeData(
            color: Theme.of(screen.context)
                .textTheme
                .labelLarge
                ?.copyWith(
                    color: _dashboard.drawerOptions.selectedTextColor ??
                        (item == selectedItem
                            ? Get.isDarkMode
                                ? Theme.of(screen.context)
                                    .textTheme
                                    .labelLarge
                                    ?.color
                                : Theme.of(screen.context)
                                    .scaffoldBackgroundColor
                            : Theme.of(screen.context).disabledColor))
                .color,
          ),
          listTileTheme: ListTileThemeData(
            horizontalTitleGap: 0.0,
            shape: _dashboard.drawerOptions.tileShape,
            tileColor: item == selectedItem
                ? (_dashboard.drawerOptions.selectedItemColor ??
                    Theme.of(screen.context).drawerTheme.backgroundColor)
                : ((_dashboard.drawerOptions.unSelectedItemColor ==
                            Colors.transparent
                        ? Theme.of(screen.context).drawerTheme.backgroundColor
                        : _dashboard.drawerOptions.unSelectedItemColor) ??
                    Theme.of(screen.context).drawerTheme.backgroundColor),
            selectedColor: item == selectedItem
                ? (Theme.of(screen.context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                            color: _dashboard.drawerOptions.selectedTextColor ??
                                (item == selectedItem
                                    ? Get.isDarkMode
                                        ? Theme.of(screen.context)
                                            .textTheme
                                            .labelLarge
                                            ?.color
                                        : Theme.of(screen.context)
                                            .scaffoldBackgroundColor
                                    : Theme.of(screen.context).disabledColor))
                        .color ??
                    Theme.of(screen.context).primaryColor)
                : (_dashboard.drawerOptions.unSelectedItemColor ??
                    Theme.of(screen.context).listTileTheme.selectedColor),
            selectedTileColor: item == selectedItem
                ? (_dashboard.drawerOptions.selectedItemColor ??
                    Theme.of(screen.context).primaryColor)
                : (_dashboard.drawerOptions.unSelectedItemColor ??
                    Theme.of(screen.context).listTileTheme.selectedTileColor),
            textColor: Theme.of(screen.context)
                .textTheme
                .labelLarge
                ?.copyWith(
                    color: _dashboard.drawerOptions.selectedTextColor ??
                        (item == selectedItem
                            ? Get.isDarkMode
                                ? Theme.of(screen.context)
                                    .textTheme
                                    .labelLarge
                                    ?.color
                                : Theme.of(screen.context)
                                    .scaffoldBackgroundColor
                            : Theme.of(screen.context).disabledColor))
                .color,
            iconColor: Theme.of(screen.context)
                .textTheme
                .labelLarge
                ?.copyWith(
                    color: _dashboard.drawerOptions.selectedTextColor ??
                        (item == selectedItem
                            ? Get.isDarkMode
                                ? Theme.of(screen.context)
                                    .textTheme
                                    .labelLarge
                                    ?.color
                                : Theme.of(screen.context)
                                    .scaffoldBackgroundColor
                            : Theme.of(screen.context).disabledColor))
                .color,
          ),
          dividerColor: Colors.transparent,
          shadowColor: _dashboard.appBarOptions.theme?.shadowColor ??
              Theme.of(screen.context).shadowColor,
        ),
        child: item.subItems.isNotEmpty
            ? ExpansionTile(
                title: Text(item.title),
                initiallyExpanded: _expanded(item.subItems)
                    .any((element) => element == selectedItem),
                leading: item.icon,
                tilePadding: _dashboard.drawerOptions.tileContentPadding,
                expandedAlignment: Alignment.center,
                expandedCrossAxisAlignment: CrossAxisAlignment.center,
                controlAffinity: ListTileControlAffinity.platform,
                collapsedTextColor: Theme.of(screen.context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                        color: _dashboard.drawerOptions.selectedTextColor ??
                            (item == selectedItem
                                ? Get.isDarkMode
                                    ? Theme.of(screen.context)
                                        .textTheme
                                        .labelLarge
                                        ?.color
                                    : Theme.of(screen.context)
                                        .scaffoldBackgroundColor
                                : Theme.of(screen.context).disabledColor))
                    .color,
                collapsedIconColor: Theme.of(screen.context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                        color: _dashboard.drawerOptions.selectedTextColor ??
                            (item == selectedItem
                                ? Get.isDarkMode
                                    ? Theme.of(screen.context)
                                        .textTheme
                                        .labelLarge
                                        ?.color
                                    : Theme.of(screen.context)
                                        .scaffoldBackgroundColor
                                : Theme.of(screen.context).disabledColor))
                    .color,
                iconColor: _dashboard.drawerOptions.selectedItemColor ??
                    Theme.of(screen.context).indicatorColor,
                textColor: _dashboard.drawerOptions.selectedItemColor ??
                    Theme.of(screen.context).indicatorColor,
                backgroundColor: _dashboard.drawerOptions.selectedItemColor ??
                    Theme.of(screen.context).listTileTheme.tileColor,
                children: [
                  for (var subItem in item.subItems)
                    _buildList(
                      selectedItem: selectedItem,
                      isLastSubItem: item.subItems.last.title == subItem.title,
                      isFirstItem: item.subItems.first.title == subItem.title,
                      item: subItem,
                      expanded: expanded,
                      isSubItem: true,
                    ),
                ],
              )
            : ListTile(
                shape: _dashboard.drawerOptions.tileShape,
                contentPadding: _dashboard.drawerOptions.tileContentPadding,
                onTap: () {
                  if (!screen.isDesktop) {
                    Navigator.of(screen.context).pop();
                  }
                  if (selectedItem.title != item.title) {
                    FlutterDashboardController.to.delegate?.toNamed(
                      "${DashboardRoutes.DASHBOARD}${item.page!.name}",
                    );
                  }
                },
                selected: item == selectedItem,
                leading: item == selectedItem
                    ? (item.selectedIcon ?? item.icon)
                    : item.icon,
                title: Text(
                  item.title,
                  textScaleFactor: Get.textScaleFactor,
                ),
              ),
      ),
    );
  }
}
