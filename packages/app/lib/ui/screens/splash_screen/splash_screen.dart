import "dart:async";

import "package:core/core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../../dependency_injection/session_manager.dart";
import "../../../router/app_routes.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final StreamSubscription<User?> _authSub;

  @override
  void initState() {
    _authSub = GetIt.I<SessionManager>().userStream.listen(_onSessionChanged);
    super.initState();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Colors.red);
  }

  void _onSessionChanged(User? user) {
    if (user != null) {
      GetIt.I<LogProvider>().log("User logged in", Severity.info);
      context.goNamed(AppRoute.home.name);
      return;
    }
    GetIt.I<LogProvider>().log("User not logged in", Severity.info);
    context.goNamed(AppRoute.login.name);
  }
}
