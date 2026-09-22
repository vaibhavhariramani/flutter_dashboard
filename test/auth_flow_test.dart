import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  Widget buildApp({required FlutterDashboarAuthConfig authConfig}) {
    return FlutterDashboardMaterialApp(
      title: 'Test',
      authConfig: authConfig,
      dashboardItems: [
        FlutterDashboardItem(
          title: 'Home',
          icon: const Icon(Icons.home),
          page: GetPage(
            name: '/home',
            page: () => const Text('Home Page Content'),
          ),
        ),
      ],
    );
  }

  testWidgets(
    'shows the built-in login view first and gates the dashboard',
    (tester) async {
      await tester.pumpWidget(
        buildApp(
          authConfig: FlutterDashboarAuthConfig(
            onLogin: (identifier, password) async =>
                identifier == 'admin' && password == 'secret',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Home Page Content'), findsNothing);

      await tester.enterText(find.byType(TextField).first, 'admin');
      await tester.enterText(find.byType(TextField).last, 'secret');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Home Page Content'), findsOneWidget);
    },
  );

  testWidgets(
    'shows an error and stays on the login view on bad credentials',
    (tester) async {
      await tester.pumpWidget(
        buildApp(
          authConfig: FlutterDashboarAuthConfig(
            onLogin: (identifier, password) async => false,
            loginErrorText: 'Nope, try again.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'admin');
      await tester.enterText(find.byType(TextField).last, 'wrong');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Nope, try again.'), findsOneWidget);
      expect(find.text('Home Page Content'), findsNothing);
    },
  );

  testWidgets(
    'renders overrideLoginView instead of the built-in form',
    (tester) async {
      await tester.pumpWidget(
        buildApp(
          authConfig: FlutterDashboarAuthConfig(
            overrideLoginView: (context) =>
                const Scaffold(body: Text('Custom Login Screen')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Login Screen'), findsOneWidget);
      expect(find.text('Welcome back'), findsNothing);
    },
  );

  testWidgets(
    'apps that never pass authConfig see no login gate (back-compat)',
    (tester) async {
      await tester.pumpWidget(
        FlutterDashboardMaterialApp(
          title: 'Test',
          dashboardItems: [
            FlutterDashboardItem(
              title: 'Home',
              icon: const Icon(Icons.home),
              page: GetPage(
                name: '/home',
                page: () => const Text('Home Page Content'),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home Page Content'), findsOneWidget);
      expect(find.text('Welcome back'), findsNothing);
    },
  );
}
