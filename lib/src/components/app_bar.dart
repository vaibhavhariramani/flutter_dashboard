part of './components.dart';

class AppBarOptions {
  final AppBarTheme? theme;
  final InputDecoration? searchDecoration;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final bool? primary;
  final double? collapsedHeight;
  final double? expandedHeight;
  final bool? floating;
  final bool? floatingOnMobile;
  final bool? pinned;
  final bool? snap;
  final bool? stretch;
  final double? stretchTriggerOffset;
  final AsyncCallback? onStretchTrigger;
  final String searchHint;
  final ShapeBorder? shape;
  final bool? showTitle;
  const AppBarOptions({
    this.flexibleSpace,
    this.bottom,
    this.primary,
    this.theme,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.floatingOnMobile = false,
    this.pinned,
    this.snap,
    this.stretch,
    this.stretchTriggerOffset,
    this.onStretchTrigger,
    this.searchDecoration,
    this.searchHint = 'Search...',
    this.shape,
    this.showTitle,
  });

  AppBarOptions copyWith(AppBarOptions? other) {
    return AppBarOptions(
      flexibleSpace: other?.flexibleSpace ?? flexibleSpace,
      bottom: other?.bottom ?? bottom,
      theme: theme == null ? other?.theme : copyTheme(theme!, other?.theme),
      primary: other?.primary ?? primary,
      collapsedHeight: other?.collapsedHeight ?? collapsedHeight,
      expandedHeight: other?.expandedHeight ?? expandedHeight,
      floating: other?.floating ?? floating,
      floatingOnMobile: other?.floatingOnMobile ?? floatingOnMobile,
      pinned: other?.pinned ?? pinned,
      snap: other?.snap ?? snap,
      stretch: other?.stretch ?? stretch,
      stretchTriggerOffset: other?.stretchTriggerOffset ?? stretchTriggerOffset,
      onStretchTrigger: other?.onStretchTrigger ?? onStretchTrigger,
      searchHint: other?.searchHint ?? searchHint,
      searchDecoration: other?.searchDecoration ?? searchDecoration,
      shape: other?.shape ?? shape,
    );
  }

  static AppBarTheme copyTheme(AppBarTheme current, AppBarTheme? _new) {
    return current.copyWith(
      foregroundColor: _new?.foregroundColor,
      elevation: _new?.elevation,
      shadowColor: _new?.shadowColor,
      shape: _new?.shape,
      iconTheme: _new?.iconTheme,
      actionsIconTheme: _new?.actionsIconTheme,
      backgroundColor: _new?.backgroundColor,
      centerTitle: _new?.centerTitle,
      titleSpacing: _new?.titleSpacing,
      toolbarHeight: _new?.toolbarHeight,
      toolbarTextStyle: _new?.toolbarTextStyle,
      titleTextStyle: _new?.titleTextStyle,
      systemOverlayStyle: _new?.systemOverlayStyle,
    );
  }
}

class _DashboardAppBar extends GetResponsiveView<FlutterDashboardController> {
  final Widget? drawerIcon;
  final bool innerBoxIsScrolled, mergeActions;
  final FocusNode focusNode;

  _DashboardAppBar({
    Key? key,
    this.drawerIcon,
    required this.innerBoxIsScrolled,
    required this.focusNode,
    required this.mergeActions,
  }) : super(key: key);

  FlutterDashboardMaterialApp get _dashboard =>
      FlutterDashboardMaterialApp.of(screen.context);

  @override
  Widget build(BuildContext context) {
    screen.context = context;

    FlutterDashboardItem selected = controller.selectedDrawerItem;

    var appBar = _dashboard.appBarOptions.copyWith(selected.appBarOptions);

    var theme = Theme.of(context);
    var appBarTheme = AppBarOptions.copyTheme(
      theme.appBarTheme,
      appBar.theme ??
          AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: DefaultTextStyle.of(context).style.color,
            elevation: appBar.theme?.elevation ?? 0,
          ),
    );
    var drawerTheme = theme.drawerTheme;
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        width: 1,
        color: Colors.transparent,
      ),
    );
    var actions = [
      ...selected.actions,
      if (!selected.overrideActions) ..._dashboard.overrideActions,
      // if (_dashboard.authConfig.rootUser != null)
      // IconButton(
      //   onPressed: () async {
      //     controller.isScreenLoading(true);
      //     await FlutterDashboardAuthService.to.logout();
      //     controller.isScreenLoading(false);
      //   },
      //   icon: const Icon(
      //     Icons.logout_rounded,
      //   ),
      // ),
    ];

    bool isFloating = screen.isDesktop
        ? (appBar.floating ?? false)
        : (appBar.floatingOnMobile ?? false);

    Widget _buildTitle() {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: selected.search == null
              ? (selected.appBarOptions?.showTitle ??
                      selected.appBarOptions?.showTitle! ??
                      _dashboard.appBarOptions.showTitle ??
                      true)
                  ? Text(
                      selected.title,
                      textScaleFactor: Get.textScaleFactor,
                    )
                  : null
              : TextField(
                  key: UniqueKey(),
                  focusNode: focusNode,
                  onChanged: selected.search,
                  decoration: appBar.searchDecoration ??
                      InputDecoration(
                        hintText: appBar.searchHint,
                        prefixIcon: const Icon(Icons.search),
                      ),
                ),
        ),
      );
    }

    return Theme(
      data: theme.copyWith(
        brightness: Theme.of(context).brightness,
        appBarTheme: appBarTheme.copyWith(
          shape: _dashboard.config.enableSpacing ||
                  _dashboard.config.enableBodySpacing
              ? appBar.shape ??
                  _dashboard.appBarOptions.theme?.shape ??
                  Theme.of(context).drawerTheme.shape ??
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    _dashboard.config.radius,
                  ))
              : null,
          shadowColor: appBar.theme?.shadowColor ??
              _dashboard.appBarOptions.theme?.shadowColor ??
              Theme.of(context).shadowColor,
          backgroundColor: screen.isDesktop
              ? appBar.theme?.backgroundColor ??
                  _dashboard.appBarOptions.theme?.backgroundColor ??
                  _dashboard.appBarOptions.theme?.backgroundColor ??
                  Theme.of(context).cardColor
              : Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: appBar.theme?.foregroundColor ??
              _dashboard.appBarOptions.theme?.foregroundColor ??
              _dashboard.appBarOptions.theme?.foregroundColor ??
              DefaultTextStyle.of(context).style.color,
          elevation: screen.isDesktop
              ? appBar.theme?.elevation ??
                  _dashboard.appBarOptions.theme?.elevation ??
                  Theme.of(context).appBarTheme.elevation ??
                  kDefaultElevation
              : 0,
          actionsIconTheme: appBar.theme?.actionsIconTheme ??
              appBar.theme?.actionsIconTheme ??
              _dashboard.appBarOptions.theme?.actionsIconTheme ??
              Theme.of(context).appBarTheme.actionsIconTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: _dashboard.drawerOptions.backgroundColor ??
              drawerTheme.backgroundColor ??
              theme.disabledColor,
          border: border,
          isDense: true,
          filled: true,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
        ),
      ),
      child: SliverPadding(
        padding: !isFloating || !screen.isDesktop
            ? EdgeInsets.zero
            : _dashboard.config.enableBodySpacing
                ? _dashboard.config.dashboardAppbarPadding ??
                    kDashboardAppbarPadding
                : _dashboard.config.enableSpacing
                    ? _dashboard.config.dashboardAppbarPadding ??
                        kDashboardAppbarPadding
                    : EdgeInsets.zero,
        sliver: isFloating || screen.isDesktop
            ? SliverToBoxAdapter(
                child: AppBar(
                  flexibleSpace: appBar.flexibleSpace,
                  toolbarHeight: appBar.expandedHeight,
                  actions: [
                    if (mergeActions && actions.length > 1)
                      _MoreMenu(children: actions)
                    else ...[
                      ...actions,
                      const SizedBox(),
                      const SizedBox(),
                    ]
                  ],
                  centerTitle: false,
                  bottom: appBar.bottom,
                  primary: appBar.primary ?? true,
                  leading: drawerIcon ?? const SizedBox(),
                  leadingWidth: drawerIcon == null ? 0 : null,
                  titleSpacing: drawerIcon != null ? 0 : null,
                  title: _buildTitle(),
                ),
              )
            : SliverAppBar(
                flexibleSpace: appBar.flexibleSpace,
                actions: [
                  if (mergeActions && actions.length > 1)
                    _MoreMenu(children: actions)
                  else ...[
                    ...actions,
                    const SizedBox(),
                    const SizedBox(),
                  ]
                ],
                centerTitle: false,
                bottom: appBar.bottom,
                primary: appBar.primary ?? true,
                collapsedHeight: appBar.collapsedHeight ??
                    _dashboard.appBarOptions.collapsedHeight,
                expandedHeight: appBar.expandedHeight ??
                    _dashboard.appBarOptions.expandedHeight,
                floating: appBar.floating ?? false,
                pinned: appBar.pinned ?? false,
                snap: appBar.snap ?? false,
                stretch: appBar.stretch ?? false,
                stretchTriggerOffset: appBar.stretchTriggerOffset ?? 100,
                onStretchTrigger: appBar.onStretchTrigger,
                forceElevated: innerBoxIsScrolled,
                leading: drawerIcon ?? const SizedBox(),
                leadingWidth: drawerIcon == null ? 0 : null,
                titleSpacing: drawerIcon != null ? 0 : null,
                title: _buildTitle(),
              ),
      ),
    );
  }
}

class _MoreMenu extends GetResponsiveView<FlutterDashboardController> {
  final List<Widget> children;
  _MoreMenu({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    // return IconButton(
    //   onPressed: () {
    //     print(children);

    //     // print(_MoreMenuRoute(
    //     //   children: children,
    //     //   barrierLabel:
    //     //       MaterialLocalizations.of(context).modalBarrierDismissLabel,
    //     // ));
    //   },
    //   icon: const Icon(Icons.more_vert_rounded),
    // );
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (BuildContext context) {
        return children.map((e) => PopupMenuItem(child: e)).toList();
      },
    );
  }
}

// class _MoreMenuRoute extends PopupRoute {
//   _MoreMenuRoute({
//     required this.children,
//     required this.barrierLabel,
//   });
//   final List<Widget> children;
//   @override
//   Animation<double> createAnimation() {
//     return CurvedAnimation(
//       parent: super.createAnimation(),
//       curve: Curves.linear,
//       reverseCurve: const Interval(0.0, 2.0 / 3.0),
//     );
//   }

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);

//   @override
//   bool get barrierDismissible => true;

//   @override
//   Color? get barrierColor => Colors.black26;

//   @override
//   final String barrierLabel;

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return SafeArea(
//       child: Align(
//         alignment: AlignmentDirectional.topEnd,
//         child: Card(
//           margin: const EdgeInsetsDirectional.only(
//             top: kToolbarHeight,
//             start: 10,
//             end: 10,
//           ),
//           child: Wrap(
//             children: children,
//             alignment: WrapAlignment.start,
//           ),
//         ),
//       ),
//     );
//   }
// }
