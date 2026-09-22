part of './auth.dart';

/// Default login screen used when
/// `FlutterDashboardMaterialApp.authConfig.overrideLoginView` is not set.
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  FlutterDashboarAuthConfig _config(BuildContext context) =>
      FlutterDashboardMaterialApp.of(context).authConfig!;

  Future<void> _submit(BuildContext context) {
    return FlutterDashboardAuthController.to.login(
      _identifierController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_config(context).overrideLoginView != null) {
      return _config(context).overrideLoginView!(context);
    }

    final config = _config(context);
    final Widget? brandLogo =
        FlutterDashboardMaterialApp.of(context).config.brandLogo;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (brandLogo != null)
                      SizedBox(
                        height: config.logoSize,
                        child: brandLogo,
                      ),
                    if (brandLogo != null) const SizedBox(height: 24),
                    Text(
                      config.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (config.subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        config.subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextField(
                      controller: _identifierController,
                      decoration: (config.useUserNameAuth
                              ? config.usernameInputDecoration
                              : config.emailInputDecoration) ??
                          InputDecoration(
                            labelText: config.useUserNameAuth
                                ? config.usernameLabel
                                : config.emailLabel,
                            filled: config.inputDecorationTheme?.filled,
                            border: config.inputDecorationTheme?.border,
                            hintStyle: config.inputDecorationTheme?.hintStyle,
                          ),
                      keyboardType: config.useUserNameAuth
                          ? TextInputType.text
                          : TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: (config.passwordInputDecoration ??
                              InputDecoration(
                                labelText: config.passwordLabel,
                                filled: config.inputDecorationTheme?.filled,
                                border: config.inputDecorationTheme?.border,
                                hintStyle:
                                    config.inputDecorationTheme?.hintStyle,
                              ))
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? config.obsecurePasswordIcon
                                : config.visiblePasswordIcon,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(context),
                    ),
                    if (FlutterDashboardAuthController.to.errorText.value !=
                        null) ...[
                      const SizedBox(height: 12),
                      Text(
                        FlutterDashboardAuthController.to.errorText.value!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: FlutterDashboardAuthController.to
                              .isSubmitting.value
                          ? null
                          : () => _submit(context),
                      child: FlutterDashboardAuthController.to.isSubmitting.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(config.loginButtonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
