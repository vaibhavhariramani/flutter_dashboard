<p align="center">
<img src="https://github.com/vaibhavhariramani/flutter_dashboard/blob/main/images/screenshots/dashboard.png?raw=true" width="100%" alt="Dashboard overview screenshot">
</p>

<p align="center">
<a href="https://pub.dev/packages/flutter_dashboard"><img src="https://img.shields.io/pub/v/flutter_dashboard.svg" alt="Pub version"></a>
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>
</p>

A Flutter package for building admin/analytics dashboards fast: a responsive collapsible drawer with nested navigation, an adaptive app bar with built-in search, full theming control, and an optional built-in login flow — all wired together with [GetX](https://pub.dev/packages/get) routing and state management, so you only write the pages.

## Features

- **Responsive layout out of the box** — a permanent sidebar on desktop/tablet widths, a slide-out `Drawer` on mobile. No breakpoint code to write.
- **Nested navigation** — group related pages under an expandable parent item (`FlutterDashboardItem.items`), to any depth.
- **Adaptive app bar** — per-page title, an optional search field that swaps in for the title, and per-page action buttons that collapse into an overflow menu on small screens.
- **Full theming control** — light/dark themes, brand logo, corner radius, spacing, and per-item app bar overrides.
- **Optional built-in login flow** — gate the whole dashboard behind authentication with a few callbacks, or drop in your own screen entirely. Fully opt-in; existing apps are unaffected.
- **Trailing badges** — attach a notification-count or "new" widget to any nav item.
- **GetX-powered** — routing, state, and dependency injection all flow through `get`, so pages are just `GetPage`s.

## Screenshots

| Dashboard | Built-in login screen |
| --- | --- |
| <img src="https://github.com/vaibhavhariramani/flutter_dashboard/blob/main/images/screenshots/dashboard.png?raw=true" width="380"> | <img src="https://github.com/vaibhavhariramani/flutter_dashboard/blob/main/images/screenshots/login.png?raw=true" width="380"> |

Both screenshots are from the runnable demo in [`example/`](example/).

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/flutter_dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDashboardMaterialApp(
      title: 'My Dashboard',
      dashboardItems: [
        FlutterDashboardItem(
          title: 'Overview',
          icon: const Icon(Icons.space_dashboard_outlined),
          page: GetPage(name: '/overview', page: () => const OverviewPage()),
        ),
        FlutterDashboardItem(
          title: 'Customers',
          icon: const Icon(Icons.people_alt_outlined),
          page: GetPage(name: '/customers', page: () => const CustomersPage()),
        ),
      ],
    );
  }
}
```

That's it — `dashboardItems` becomes both the drawer navigation and the routing table. Run the full example with:

```bash
cd example
flutter run -d chrome
```

## Configuration

Everything below is optional; the package ships sensible defaults, so start with the quick start above and layer on configuration as you need it.

### `FlutterDashboardMaterialApp`

The root widget — replaces `MaterialApp` / `GetMaterialApp`.

| Parameter | Type | Description |
| --- | --- | --- |
| `title` | `String` | App title. |
| `dashboardItems` | `List<FlutterDashboardItem>` | The nav items / routing table. Must not be empty. |
| `config` | `DashboardConfig` | Theming, spacing, and locale settings (below). |
| `appBarOptions` | `AppBarOptions` | Default app bar behavior, overridable per item. |
| `drawerOptions` | `DrawerOptions` | Drawer styling, header/footer, footer nav items. |
| `authConfig` | `FlutterDashboardAuthConfig?` | Enables the built-in login flow when set (below). Omit to disable — default behavior is unchanged. |
| `rootPages` | `List<GetPage>` | Extra top-level `GetPage`s alongside the dashboard (e.g. a standalone settings page outside the drawer). |
| `overrideRootPage` | `Widget Function(BuildContext, GetDelegate, GetNavConfig?)?` | Replace the router outlet that decides between your custom root pages and the dashboard shell. |
| `dashboardMiddlewares` | `List<GetMiddleware>?` | GetX middlewares applied to the whole dashboard route tree. |
| `notFoundPage` | `Widget` | Shown for unknown routes. |
| `builder` | `Widget Function(BuildContext, Widget?)?` | Standard `MaterialApp.builder` passthrough (e.g. for a global overlay). |

### `DashboardConfig`

Passed as `config:`. Controls theming and layout, not navigation.

| Field | Default | Description |
| --- | --- | --- |
| `brandLogo` | `null` | Widget shown in the drawer header (and the login screen, if enabled). |
| `theme` / `darkTheme` / `themeMode` | — | Standard Flutter theming. |
| `radius` | `10` | Corner radius used across cards, the app bar, and the drawer. |
| `enableSpacing` | `true` | Adds outer padding/elevation around the dashboard shell on desktop. |
| `enableBodySpacing` | `false` | Adds `dashboardContentPadding` inside the body area too. |
| `dashboardContentPadding` / `dashboardAppbarPadding` | — | Fine-grained padding once `enableBodySpacing` is on. |
| `hasScrollingBody` | `true` | Whether the page body itself scrolls (disable if your page manages its own scrolling). |
| `mouseCursor` | `null` | Cursor for the dashboard shell (desktop/web). |
| `locale`, `localizationsDelegates`, `supportedLocales`, `translations`, ... | — | Passed straight through to `GetMaterialApp`. |

### `FlutterDashboardItem`

One entry in the drawer / routing table.

```dart
FlutterDashboardItem(
  title: 'Customers',
  icon: const Icon(Icons.people_alt_outlined),
  selectedIcon: const Icon(Icons.people_alt), // shown when active
  page: GetPage(name: '/customers', page: () => const CustomersPage()),
  search: (value) => myController.filter(value), // swaps the title for a search field
  actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
  trailing: const CircleAvatar(radius: 10, child: Text('3', style: TextStyle(fontSize: 11))), // notification count, "new" chip, etc.
  appBarOptions: const AppBarOptions(showTitle: false), // per-page app bar override
)
```

Group related pages with `FlutterDashboardItem.items(title:, icon:, subItems:)` — it renders as an expandable entry and has no `page` of its own.

### `AppBarOptions`

Passed as `appBarOptions:` on the app (default for every page) and/or per-item (overrides the default for that page only). Covers `theme`, `flexibleSpace`, `bottom`, `expandedHeight`/`collapsedHeight`, `floating`/`floatingOnMobile`, `pinned`, `snap`, `stretch`, `shape`, `showTitle`, and the search field's `searchHint`/`searchDecoration`.

### `DrawerOptions`

Passed as `drawerOptions:`. Covers `backgroundColor`/`image`/`gradient`, `headers` (widgets above the nav list), `footer`, `footerNavItems` (a second nav list pinned to the bottom, e.g. Settings/Help), `logo`, `selectedItemColor`/`unSelectedItemColor`/`selectedTextColor`, `tilePadding`/`tileContentPadding`/`tileShape`, and `overrideHeader` for a fully custom drawer header.

### Authentication (`authConfig`)

Pass a `FlutterDashboardAuthConfig` to gate the dashboard behind a login screen — omit it entirely and behavior is unchanged.

```dart
FlutterDashboardMaterialApp(
  authConfig: FlutterDashboardAuthConfig(
    title: 'Welcome back',
    onLogin: (identifier, password) async {
      final ok = await myAuthApi.login(identifier, password);
      return ok; // true logs the user in, false shows loginErrorText
    },
    onLogout: () async => myAuthApi.logout(),
    isAuthenticated: () => myAuthApi.hasValidSession(), // checked once, on startup
  ),
  // ...
)
```

- Leave `onLogin` unset and the login screen still renders (useful while wiring up your backend), it just always shows `loginErrorText`.
- Provide `overrideLoginView: (context) => MyLoginScreen()` instead of `onLogin` to replace the built-in screen entirely — you're then responsible for calling `FlutterDashboardAuthController.to.login(...)` yourself.
- `showLogoutButton` (default `true`) adds a logout action to the app bar; set it to `false` to build your own.
- The built-in screen's copy and inputs are all configurable: `title`, `subtitle`, `emailLabel`/`usernameLabel`/`passwordLabel`, `useUserNameAuth` (switch from email to username), `loginButtonText`, `loginErrorText`, `*InputDecoration`, `visiblePasswordIcon`/`obsecurePasswordIcon`.
- `FlutterDashboarAuthConfig` (the original, typo'd class name) still works — `FlutterDashboardAuthConfig` is a drop-in alias.

## Roadmap / ideas

A few things worth adding next, if you'd find them useful — contributions welcome:

- **Persisted session helper** — a small `GetStorage`-backed default for `isAuthenticated`/`onLogin`/`onLogout` (the package already depends on `get_storage`), so a token-based login needs zero boilerplate.
- **Collapsed-drawer mode on desktop** — an icon-only rail instead of fully hiding the sidebar.
- **Breadcrumbs** for deeply nested `subItems`.
- **Theme toggle action** built into the app bar (light/dark), reading `DashboardConfig.themeMode`.

## Additional information

### Resources

To learn more about these Resources you can Refer to some of these articles written by Me:-

[https://vaibhavji.medium.com/deep-learning-in-android-using-tensorflow-lite-with-flutter-f6e18994748](https://vaibhavji.medium.com/deep-learning-in-android-using-tensorflow-lite-with-flutter-f6e18994748)

- [Medium](https://medium.com/geeky-bawa)
- [geeky Traveller](https://sites.google.com/view/geeky-traveller/)
- [Blogs](https://github.com/vaibhavhariaramani/blogs)
- [Youtube](https://www.youtube.com/channel/UCy7amUpLnsRLEMIaJGGBYog)[![Youtube Badge](https://img.shields.io/badge/-Geeky_Bawa-1ca0f1?style=flat-circle&labelColor=d54b3d&logo=youtube&logoColor=white&link=https://www.youtube.com/channel/UCy7amUpLnsRLEMIaJGGBYog)](https://www.youtube.com/channel/UCy7amUpLnsRLEMIaJGGBYog)

### Don't forget to tag us

if you use this repo in  your project don't forget to mention us as Contributer in it . And Don't forget to tag us [Linkedin](https://www.linkedin.com/in/vaibhav-hariramani-087488186/),[ instagram](https://www.instagram.com/geeky_baba_/?hl=en),[ facebook](https://www.facebook.com/jayesh.hariramani.3) ,[ twitter](https://www.linkedin.com/in/vaibhav-hariramani-087488186/), [ Github](https://github.com/vaibhavhariaramani)

============================================================================
# Made with ❤️by Vaibhav Hariramani
#### About me

I’ve always been the kind of developer who learns by building.
What started with IoT, Android, machine learning, and computer vision gradually turned into a career around cloud infrastructure, DevOps, SRE, distributed systems, and AI.
Today I spend most of my time designing and automating cloud systems, working with Kubernetes, Terraform, AWS, Azure, CI/CD, observability, and Python — but I still make time for the kind of projects that started everything: building random ideas just to see if I can.
I’ve worked at Jaguar Land Rover, Avaya, 42Gears, and OneWorld, and completed my MSc in Computer Science at University College Dublin.
Some repositories here are polished projects. Others are experiments, old ideas, or things I built simply because I was curious.
That’s probably the best description of me as a developer: curious enough to build it, and stubborn enough to figure out how it works.

[My PortFolio](https://vaibhavhariaramani.github.io/)
You can find me at:-
[Linkedin](https://www.linkedin.com/in/vaibhav-hariramani-087488186/) or [Github](https://github.com/vaibhavhariaramani) .

Email: [vaibhav.hariramani01@gmail.com](mailto:vaibhav.hariramani01@gmail.com)



Happy coding ❤️ .

### Follow me

[![Linkedin Badge](https://img.shields.io/badge/-VaibhavHariramani-blue?style=flat-circle&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/vaibhav-hariramani-087488186/)](https://www.linkedin.com/in/vaibhav-hariramani-087488186/) [![Instagram Badge](https://img.shields.io/badge/-VaibhavHariramani-e02c73?style=flat-circle&labelColor=e02c73&logo=Instagram&logoColor=white&link=https://www.instagram.com/vaibhav.hariramani/?hl=en)](https://www.instagram.com/vaibhav.hariramani/?hl=en) [![Twitter Badge](https://img.shields.io/badge/-VaibhavHariramani-1ca0f1?style=flat-circle&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/vaibhavhariram2)](https://twitter.com/vaibhavhariram2) [![GitHub Badge](https://img.shields.io/badge/-@Vaibhavhariaramani-24292e?style=flat-circle&labelColor=24292e&logo=github&logoColor=white&link=https://github.com/vaibhavhariaramani)](https://github.com/vaibhavhariaramani) [![Gmail Badge](https://img.shields.io/badge/-VaibhavHariramani-d54b3d?style=flat-circle&labelColor=d54b3d&logo=gmail&logoColor=white&link=mailto:vaibhav.hariramani01@gmail.com)](mailto:vaibhav.hariramani01@gmail.com) [![Medium Badge](https://img.shields.io/badge/-VaibhavHariramani-d54b3d?style=flat-circle&labelColor=d54b3d&logo=medium&logoColor=white&link=https://medium.com/geeky-bawa)](https://medium.com/geeky-bawa)
