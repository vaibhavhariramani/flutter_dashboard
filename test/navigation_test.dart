import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets(
    'drawer nav items are populated by default '
    '(regression: FlutterDashboardNavService.enabledRoutes never fired)',
    (tester) async {
      await tester.pumpWidget(
        FlutterDashboardMaterialApp(
          title: 'Test',
          dashboardItems: [
            FlutterDashboardItem(
              title: 'Home',
              icon: const Icon(Icons.home),
              page: GetPage(name: '/home', page: () => const Text('Home')),
            ),
            FlutterDashboardItem(
              title: 'Reports',
              icon: const Icon(Icons.bar_chart),
              page: GetPage(
                name: '/reports',
                page: () => const Text('Reports'),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        FlutterDashboardNavService.to.finalRoutes.map((e) => e.title),
        containsAll(<String>['Home', 'Reports']),
      );
    },
  );
}
