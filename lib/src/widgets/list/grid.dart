part of './flutter_dashboard_list.dart';

class FlutterDashboardGridDelegates {
  static SliverSimpleGridDelegateWithFixedCrossAxisCount fit(
    int? length,
    int crossAxisCount,
    int fit,
  ) =>
      SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        // crossAxisSpacing: 15,
        // mainAxisSpacing: 15,
        // staggeredTileCount: length,
        // staggeredTileBuilder: (int index) => StaggeredTile.fit(fit),
      );

  static SliverSimpleGridDelegate columns_2({
    required double width,
    required int? length,
  }) =>
      fit(length, 2, 1);
  static SliverSimpleGridDelegate columns_1({
    required double width,
    required int? length,
  }) =>
      fit(length, 1, 1);
  static SliverSimpleGridDelegate columns_3({
    required double width,
    required int? length,
  }) =>
      fit(length, 3, 1);
  static SliverSimpleGridDelegate columns_4({
    required double width,
    required int? length,
  }) =>
      fit(length, 4, 1);
  static SliverSimpleGridDelegate columns_5({
    required double width,
    required int? length,
  }) =>
      fit(length, 5, 1);
  static SliverSimpleGridDelegate columns_6({
    required double width,
    required int? length,
  }) =>
      fit(length, 6, 1);

  static SliverSimpleGridDelegate responsive({
    required ResponsiveScreen screen,
    required int? length,
    SliverGridDelegate? small,
    SliverGridDelegate? medium,
    SliverGridDelegate? large,
    SliverGridDelegate? extraLarge,
  }) {
    if (screen.isDesktop) {
      return FlutterDashboardGridDelegates.columns_4(
          width: screen.context.width, length: length);
    } else if (screen.isTablet) {
      if (screen.context.isLargeTablet) {
        return FlutterDashboardGridDelegates.columns_3(
            width: screen.context.width, length: length);
      } else if (screen.context.isSmallTablet) {
        return FlutterDashboardGridDelegates.columns_2(
            width: screen.context.width, length: length);
      } else {
        return FlutterDashboardGridDelegates.columns_2(
            width: screen.context.width, length: length);
      }
    } else if (screen.isPhone) {
      return FlutterDashboardGridDelegates.columns_1(
          width: screen.context.width, length: length);
    } else if (screen.isWatch) {
      throw UnimplementedError();
    } else {
      return FlutterDashboardGridDelegates.columns_5(
          width: screen.context.width, length: length);
    }
  }
}
