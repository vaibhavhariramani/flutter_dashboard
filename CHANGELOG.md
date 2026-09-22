## 0.0.1

- Ready-to-use UI components for creating stunning admin dashboards.
- Customizable Widgets Easily tailor the look and feel to match your project's style.
- Responsive Components adapt seamlessly to different screen sizes.
- Quick Integration: Save development time by plugging these widgets into your project.

## 1.0.1

- Added steps to use

## 2.1.0

- Added a built-in authentication/login flow, opt-in via the new
  `FlutterDashboardMaterialApp.authConfig` parameter. When omitted, behavior
  is unchanged.
  - `FlutterDashboarAuthConfig` (aliased as `FlutterDashboardAuthConfig`) now
    supports `onLogin`, `onLogout`, `isAuthenticated`, and `overrideLoginView`
    for a fully custom login screen, plus label/text customization for the
    built-in one.
  - The dashboard automatically shows the login screen until authenticated,
    and can show a logout action in the app bar (`showLogoutButton`).
- Fixed a crash in the app bar title logic that could throw a null-check
  error when a page's `AppBarOptions.showTitle` was left unset.
- Fixed `AppBarOptions.copyWith` silently dropping `showTitle`, so per-page
  app bar options can now actually override it.
- Fixed `DashboardPages` accumulating duplicate routes if
  `FlutterDashboardMaterialApp` is built more than once in the same process
  (e.g. in tests, or a full widget remount).
- Bumped the minimum `get` dependency to `^4.6.6` to fix a build failure
  against current Flutter versions (`ThemeData.backgroundColor` was removed
  upstream).
- Added a test suite covering the new auth flow.

## 2.2.0

- **Fixed a major bug: the drawer's navigation list was always empty.**
  `FlutterDashboardNavService.enabledRoutes` was only ever consumed
  reactively (`ever(enabledRoutes, ...)`), which fires on *changes*, not on
  its initial value — and nothing in the package ever wrote to it. So
  `finalRoutes` (what the drawer renders) never populated unless a consumer
  app happened to assign `enabledRoutes` itself. `dashboardItems` now show
  up in the drawer by default, as originally intended.
- Added `FlutterDashboardItem.trailing`, an optional widget rendered at the
  end of a nav item's drawer tile (notification-count badges, "new" chips,
  etc.).
- Added a runnable example app under `example/` demonstrating navigation,
  nested items, search, theming, and the built-in login flow.
- Added screenshots to the README, generated from the example app.
- Added `repository`/`issue_tracker` to `pubspec.yaml` and tightened the
  package `description` for pub.dev.
- Added regression tests for the drawer population fix and the new
  `trailing` field.