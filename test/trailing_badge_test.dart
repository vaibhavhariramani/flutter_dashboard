import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets('renders a trailing badge widget on a dashboard nav item',
      (tester) async {
    // Force a desktop-width layout so the drawer renders as a permanent
    // sidebar instead of a closed Scaffold drawer that needs opening.
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      FlutterDashboardMaterialApp(
        title: 'Test',
        dashboardItems: [
          FlutterDashboardItem(
            title: 'Inbox',
            icon: const Icon(Icons.inbox),
            trailing: const Text('3'),
            page: GetPage(name: '/inbox', page: () => const Text('Inbox')),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
  });
}
