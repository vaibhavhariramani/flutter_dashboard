library flutter_dashboard_list;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

part './grid.dart';

typedef FlutterDashboardListWidgetBuilder = Widget Function(BuildContext, int);

enum FlutterDashboardListType {
  Normal,
  Grid,
  Custom,
}

typedef FlutterDashboardGridDelegate = SliverSimpleGridDelegate;

// ignore: must_be_immutable
class FlutterDashboardListView<T> extends GetResponsiveView<T> {
  bool? isSliverItem;
  Iterable<T>? items;
  int? childCount;
  EdgeInsetsGeometry? padding;
  FlutterDashboardListWidgetBuilder? buildItem;
  FlutterDashboardListWidgetBuilder? dividerBuilder;
  List<Widget>? slivers;
  ScrollPhysics? physics;
  Axis? scrollDirection;
  ScrollBehavior? scrollBehavior;
  bool? shrinkWrap;
  bool? reverse;
  FlutterDashboardListType? listType;
  FlutterDashboardGridDelegate? gridDelegate;
  double? crossAxisSpacing;
  double? mainAxisSpacing;
  ScrollController? scrollController;

  FlutterDashboardListView.list({
    Key? key,
    required this.isSliverItem,
    this.items = const [],
    required this.childCount,
    this.padding,
    required this.buildItem,
    required this.listType,
    this.dividerBuilder,
    this.scrollController,
  }) : super(key: key) {
    crossAxisSpacing = null;
    mainAxisSpacing = null;
    slivers = const [];
    physics = null;
    scrollDirection = null;
    scrollBehavior = null;
    shrinkWrap = null;
    reverse = null;
    dividerBuilder = null;
    gridDelegate = null;
  }

  FlutterDashboardListView.grid({
    Key? key,
    required this.isSliverItem,
    this.items = const [],
    required this.childCount,
    this.padding,
    required this.buildItem,
    required this.listType,
    this.physics,
    this.scrollDirection,
    this.shrinkWrap,
    this.reverse,
    this.gridDelegate,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.scrollController,
  }) : super(key: key) {
    slivers = const [];
    scrollBehavior = null;
    dividerBuilder = null;
  }

  FlutterDashboardListView({
    Key? key,
    required this.slivers,
    this.physics,
    this.scrollDirection,
    this.scrollBehavior,
    this.shrinkWrap,
    this.reverse,
    this.scrollController,
  }) : super(key: key) {
    crossAxisSpacing = null;
    mainAxisSpacing = null;
    listType = null;
    buildItem = null;
    isSliverItem = false;
    items = null;
    childCount = null;
    padding = null;
    dividerBuilder = null;
    gridDelegate = null;
  }

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    if (listType == null) {
      return CustomScrollView(
        controller: scrollController,
        physics: physics,
        scrollDirection: scrollDirection ?? Axis.vertical,
        scrollBehavior: scrollBehavior ?? ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        shrinkWrap: shrinkWrap ?? true,
        slivers: slivers ?? [],
      );
    } else {
      if (listType == FlutterDashboardListType.Grid) {
        if (isSliverItem ?? true) {
          return SliverPadding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
            sliver: SliverMasonryGrid(
              gridDelegate: gridDelegate ??
                  FlutterDashboardGridDelegates.responsive(
                    screen: screen,
                    length: childCount,
                  ),
              crossAxisSpacing: crossAxisSpacing!,
              mainAxisSpacing: mainAxisSpacing!,
              delegate: SliverChildBuilderDelegate(
                buildItem!,
                childCount: childCount,
              ),
            ),
          );
        } else {
          return Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
            child: MasonryGridView.builder(
              controller: scrollController,
              physics: physics,
              scrollDirection: scrollDirection ?? Axis.vertical,
              shrinkWrap: shrinkWrap ?? true,
              gridDelegate: gridDelegate ??
                  FlutterDashboardGridDelegates.responsive(
                    screen: screen,
                    length: childCount,
                  ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              crossAxisSpacing: crossAxisSpacing!,
              mainAxisSpacing: mainAxisSpacing!,
              itemBuilder: buildItem!,
              itemCount: childCount,
            ),
          );
        }
      } else {
        if (isSliverItem ?? true) {
          return SliverPadding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                buildItem!,
                childCount: childCount,
              ),
            ),
          );
        } else {
          return Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
            child: ListView.separated(
              controller: scrollController,
              physics: physics,
              scrollDirection: scrollDirection ?? Axis.vertical,
              shrinkWrap: shrinkWrap ?? true,
              itemBuilder: buildItem!,
              itemCount: childCount ?? 0,
              separatorBuilder: dividerBuilder ??
                  (_, __) => const Divider(
                        color: Colors.transparent,
                        height: 5,
                      ),
            ),
          );
        }
      }
    }
  }
}
