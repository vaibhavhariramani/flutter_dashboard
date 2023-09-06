part of './flutter_dashboard_navigation.dart';

abstract class DashboardRoutes {
  DashboardRoutes._();

  static const DASHBOARD = _Paths.DASHBOARD;
  static const ERROR404 = _Paths.ERROR404;
}

abstract class _Paths {
  static const DASHBOARD = '/dashboard';
  static const ERROR404 = '/error404';
}
