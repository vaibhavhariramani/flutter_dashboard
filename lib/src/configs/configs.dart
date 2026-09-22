library configs;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dashboard/src/components/components.dart';
import 'package:get/get.dart';

class FormInputDecoration {
  final bool? filled;
  final InputBorder? border;
  final TextStyle? hintStyle;

  const FormInputDecoration({
    this.filled,
    this.border,
    this.hintStyle,
  });
}

class FlutterDashboarAuthConfig {
  final double? logoSize;
  final InputDecoration? emailInputDecoration;
  final InputDecoration? passwordInputDecoration;
  final InputDecoration? usernameInputDecoration;
  final FormInputDecoration? inputDecorationTheme;
  final bool useUserNameAuth;
  final IconData visiblePasswordIcon;
  final IconData obsecurePasswordIcon;

  /// Fully replaces the built-in login screen with a custom widget.
  ///
  /// When null (the default), the package renders its own login view using
  /// the fields on this config (labels, decorations, icons, [onLogin]).
  final Widget Function(BuildContext context)? overrideLoginView;

  /// Called when the (built-in or custom) login view submits credentials.
  ///
  /// Receives the email/username and password entered by the user. Return
  /// `true` on a successful login and `false` to keep the user on the login
  /// screen and surface [loginErrorText].
  final Future<bool> Function(String identifier, String password)? onLogin;

  /// Called when the user taps the logout action (see [showLogoutButton]).
  final Future<void> Function()? onLogout;

  /// Synchronously reports whether the app currently has an authenticated
  /// session, e.g. by checking a persisted token. Used to decide the initial
  /// authentication state when the dashboard first builds.
  final bool Function()? isAuthenticated;

  final String title;
  final String? subtitle;
  final String emailLabel;
  final String usernameLabel;
  final String passwordLabel;
  final String loginButtonText;
  final String loginErrorText;

  /// Shows a logout action in the dashboard app bar. Only takes effect when
  /// this auth config is provided to [FlutterDashboardMaterialApp.authConfig].
  final bool showLogoutButton;
  final IconData logoutIcon;

  const FlutterDashboarAuthConfig({
    this.logoSize,
    this.emailInputDecoration,
    this.passwordInputDecoration,
    this.usernameInputDecoration,
    this.inputDecorationTheme,
    this.useUserNameAuth = false,
    this.visiblePasswordIcon = Icons.visibility,
    this.obsecurePasswordIcon = Icons.visibility_off,
    this.overrideLoginView,
    this.onLogin,
    this.onLogout,
    this.isAuthenticated,
    this.title = 'Welcome back',
    this.subtitle,
    this.emailLabel = 'Email',
    this.usernameLabel = 'Username',
    this.passwordLabel = 'Password',
    this.loginButtonText = 'Login',
    this.loginErrorText = 'Invalid credentials, please try again.',
    this.showLogoutButton = true,
    this.logoutIcon = Icons.logout_rounded,
  }) : assert(
          overrideLoginView == null || onLogin == null,
          'Provide either overrideLoginView or onLogin, not both: '
          'overrideLoginView takes over the whole screen, so the built-in '
          'form (and onLogin) never runs.',
        );
}

/// Correctly spelled alias of [FlutterDashboarAuthConfig].
///
/// The original class name shipped with a typo; it is kept for backwards
/// compatibility. Prefer this alias in new code.
typedef FlutterDashboardAuthConfig = FlutterDashboarAuthConfig;

class DashboardConfig {
  final Widget? brandLogo;
  final bool enableSpacing;
  final AppBarOptions? appBarOptions;
  final bool debugShowCheckedModeBanner;
  final SystemMouseCursor? mouseCursor;
  final bool hasScrollingBody;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Locale? fallbackLocale;
  final Iterable<Locale> supportedLocales;
  final TextDirection? textDirection;
  final Translations? translations;
  final bool enableBodySpacing;
  final EdgeInsetsGeometry dashboardContentPadding;
  final ShapeBorder? dashboardContentShape;
  final EdgeInsetsGeometry? dashboardAppbarPadding;
  final double radius;

  const DashboardConfig({
    this.brandLogo,
    this.appBarOptions,
    this.enableSpacing = true,
    this.debugShowCheckedModeBanner = true,
    this.mouseCursor,
    this.dashboardContentShape,
    this.hasScrollingBody = true,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.fallbackLocale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.textDirection,
    this.translations,
    this.radius = kDefaultRadius,
    this.dashboardAppbarPadding = kDashboardAppbarPadding,
    this.dashboardContentPadding = kDashboardContentPadding,
    this.enableBodySpacing = false,
  });
}
