import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/session_notifier.dart";
import "../../../router/app_routes.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SessionNotifier _sessionNotifier;

  @override
  void initState() {
    _sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
    _sessionNotifier.addListener(_onSessionChanged);
    super.initState();
  }

  @override
  void dispose() {
    _sessionNotifier.removeListener(_onSessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Colors.red);
  }

  void _onSessionChanged() {
    print(_sessionNotifier.isLoggedIn);
    if (_sessionNotifier.isLoggedIn) {
      context.go(AppRoute.home.path);
      return;
    }
    context.go(AppRoute.login.path);
  }
}
