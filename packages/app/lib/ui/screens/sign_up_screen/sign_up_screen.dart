import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";

import "../../../notifiers/session_notifier.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create a new account",
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
                    hintText: "Enter a password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _repeatPasswordController,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value != _passwordController.text)
                      ? "Passwords must match"
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Repeat Password",
                    hintText: "Enter again the password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  child: const Text("Sign Up"),
                  onPressed: () {
                    context
                        .read<SessionNotifier>()
                        .register(
                          email: _emailController.text,
                          password: _passwordController.text,
                        )
                        .then((value) {
                          if (context.mounted) {
                            context.pop();
                          }
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
