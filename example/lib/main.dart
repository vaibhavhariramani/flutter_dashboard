import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDashboardMaterialApp(
      title: 'Flutter Dashboard Demo',
      config: DashboardConfig(
        brandLogo: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.dashboard_rounded, color: Color(0xFF6C5CE7)),
            SizedBox(width: 8),
            Text(
              'Nimbus',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
        radius: 16,
      ),
      appBarOptions: const AppBarOptions(
        expandedHeight: 64,
      ),
      drawerOptions: DrawerOptions(
        selectedItemColor: const Color(0xFF6C5CE7),
        footerNavItems: [
          FlutterDashboardItem(
            title: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            page: GetPage(name: '/settings', page: () => const SettingsPage()),
          ),
        ],
      ),
      // Remove `authConfig` entirely to disable the login flow and go
      // straight to the dashboard - it is fully opt-in.
      authConfig: FlutterDashboardAuthConfig(
        title: 'Nimbus Admin',
        subtitle: 'Sign in with admin / admin123 to continue',
        onLogin: (identifier, password) async {
          await Future.delayed(const Duration(milliseconds: 600));
          return identifier == 'admin' && password == 'admin123';
        },
      ),
      dashboardItems: [
        FlutterDashboardItem(
          title: 'Overview',
          icon: const Icon(Icons.space_dashboard_outlined),
          selectedIcon: const Icon(Icons.space_dashboard),
          page: GetPage(name: '/overview', page: () => const OverviewPage()),
        ),
        FlutterDashboardItem.items(
          title: 'Analytics',
          icon: const Icon(Icons.insights_outlined),
          subItems: [
            FlutterDashboardItem(
              title: 'Traffic',
              icon: const Icon(Icons.show_chart),
              page: GetPage(name: '/traffic', page: () => const TrafficPage()),
            ),
            FlutterDashboardItem(
              title: 'Revenue',
              icon: const Icon(Icons.attach_money),
              page: GetPage(name: '/revenue', page: () => const RevenuePage()),
            ),
          ],
        ),
        FlutterDashboardItem(
          title: 'Customers',
          icon: const Icon(Icons.people_alt_outlined),
          selectedIcon: const Icon(Icons.people_alt),
          search: (value) => debugPrint('Searching customers for "$value"'),
          page: GetPage(name: '/customers', page: () => const CustomersPage()),
        ),
      ],
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back 👋', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            "Here's what's happening across your workspace today.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _StatCard(label: 'Active Users', value: '2,431', icon: Icons.groups_rounded),
              _StatCard(label: 'Revenue', value: '\$18.2k', icon: Icons.payments_rounded),
              _StatCard(label: 'Conversion', value: '4.6%', icon: Icons.trending_up_rounded),
              _StatCard(label: 'Open Tickets', value: '12', icon: Icons.support_agent_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class TrafficPage extends StatelessWidget {
  const TrafficPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Traffic analytics go here.'));
  }
}

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Revenue analytics go here.'));
  }
}

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = List.generate(8, (i) => 'Customer ${i + 1}');
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: customers.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(customers[index]),
        subtitle: const Text('Active'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings go here.'));
  }
}
