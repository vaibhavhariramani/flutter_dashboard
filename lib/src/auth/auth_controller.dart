part of './auth.dart';

/// Holds the authentication state used by the dashboard's login flow.
///
/// Registered permanently by [FlutterDashboardMaterialApp] only when it is
/// constructed with a non-null `authConfig`. Existing apps that never pass
/// `authConfig` never register this controller and are completely
/// unaffected by the auth feature.
class FlutterDashboardAuthController extends GetxController {
  static FlutterDashboardAuthController get to =>
      Get.find<FlutterDashboardAuthController>();

  final FlutterDashboarAuthConfig config;

  FlutterDashboardAuthController(this.config);

  final RxBool isAuthenticated = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString errorText = RxnString();

  @override
  void onInit() {
    isAuthenticated(config.isAuthenticated?.call() ?? false);
    super.onInit();
  }

  Future<bool> login(String identifier, String password) async {
    errorText(null);
    isSubmitting(true);
    final bool success = await config.onLogin?.call(identifier, password) ??
        false;
    isSubmitting(false);
    isAuthenticated(success);
    if (!success) {
      errorText(config.loginErrorText);
    }
    return success;
  }

  Future<void> logout() async {
    await config.onLogout?.call();
    isAuthenticated(false);
  }
}
