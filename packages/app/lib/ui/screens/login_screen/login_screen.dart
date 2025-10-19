import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_signin_button/flutter_signin_button.dart";
import "package:ui/ui.dart";

import "../../../dependency_injection/session_manager.dart";
import "../../../router/app_routes.dart";
import "../../extensions/ui_context_extension.dart";
import "../../images/app_images.dart";
import "../../widgets/todo_feature_alert_dialog.dart";
import "widgets/or_divider.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    AppImages.markerLogin,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Let's get started!",
                            style: context.textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            final RegExp emailRegex = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Enter a valid password"
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == false) {
                              return;
                            }

                            context.showProgressIndicator();
                            GetIt.I<SessionManager>()
                                .login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                .whenComplete(() {
                                  if (context.mounted) {
                                    context.hideProgressIndicator();
                                  }
                                })
                                .then((_) {
                                  if (context.mounted) {
                                    context.goNamed(AppRoute.home.name);
                                  }
                                })
                                .catchError((dynamic error) {
                                  if (context.mounted) {
                                    context.showErrorBanner(
                                      "Login failed - $error",
                                    );
                                  }
                                });
                          },
                          child: const Text("Login"),
                        ),
                        const SizedBox(height: 8),
                        const OrDivider(),
                        const SizedBox(height: 8),
                        SignInButton(
                          Buttons.Google,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: context.colorScheme.outline,
                            ),
                          ),
                          elevation: 0,
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) =>
                                  const TodoFeatureAlertDialog(),
                            );
                          },
                        ),
                        SignInButton(
                          Buttons.AppleDark,
                          shape: const StadiumBorder(),
                          elevation: 0,
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) =>
                                  const TodoFeatureAlertDialog(),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) =>
                                  const TodoFeatureAlertDialog(),
                            );
                            //context.goNamed(AppRoute.signUp.name);
                          },
                          child: const Text("Don't have an account? Sign up"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
