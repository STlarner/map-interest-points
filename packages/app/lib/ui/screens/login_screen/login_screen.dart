import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_signin_button/flutter_signin_button.dart";
import "package:provider/provider.dart";

import "../../../providers/session_provider.dart";
import "../../images/app_images.dart";
import "widgets/or_divider.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                Image.asset(AppImages.tokyoSigns, fit: BoxFit.fitHeight),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {
                          context
                              .read<SessionProvider>()
                              .login(email: "megaminx96@gmail.com", password: "megaminx96!")
                              .then((_) {
                                if (context.mounted) {
                                  context.pushNamed("map");
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
