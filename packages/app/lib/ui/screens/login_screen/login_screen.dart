import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_signin_button/flutter_signin_button.dart";
import "package:provider/provider.dart";

import "../../../notifiers/session_notifier.dart";
import "../../../router/app_routes.dart";
import "../../extensions/ui_context_extension.dart";
import "../../images/app_images.dart";
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
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                Image.asset(AppImages.tokyoSigns, fit: BoxFit.fitWidth),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                            style: Theme.of(context).textTheme.headlineLarge,
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
                            final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
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
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              (value == null || value.isEmpty) ? "Enter a valid password" : null,
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
                            context
                                .read<SessionNotifier>()
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
                                    context.go(AppRoute.home.path);
                                  }
                                })
                                .catchError((dynamic error) {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Login failed - $error"),
                                      action: SnackBarAction(
                                        label: "Close",
                                        onPressed: () {
                                          // Undo logic here
                                        },
                                      ),
                                    ),
                                  );
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
                            side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          ),
                          elevation: 0,
                          onPressed: () {
                            GetIt.I<LogProvider>().log(
                              "Google Sign In Button Pressed",
                              Severity.debug,
                            );
                          },
                        ),
                        SignInButton(
                          Buttons.AppleDark,
                          shape: const StadiumBorder(),
                          elevation: 0,
                          onPressed: () {
                            GetIt.I<LogProvider>().log(
                              "Apple Sign In Button Pressed",
                              Severity.debug,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            GetIt.I<LogProvider>().log("Sign Up Button Pressed", Severity.debug);
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
