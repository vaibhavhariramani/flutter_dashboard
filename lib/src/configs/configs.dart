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

  const FlutterDashboarAuthConfig({
    this.logoSize,
    this.emailInputDecoration,
    this.passwordInputDecoration,
    this.usernameInputDecoration,
    this.inputDecorationTheme,
    this.useUserNameAuth = false,
    this.visiblePasswordIcon = Icons.visibility,
    this.obsecurePasswordIcon = Icons.visibility_off,
  })
  // : assert(
  //         overrideLoginFunction == null || loginUrl == null,
  //         'Can not provide both loginUrl and overrideLoginFunction',
  //       ),
  //       assert(
  //         overrideLoginFunction == null || rootUser == null,
  //         'Can not provide both rootUser and overrideLoginFunction',
  //       )
  ;
}

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
