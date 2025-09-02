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

  //TODO: sistemare get token e navigazione
  //TODO: il token scade, capire come gestire refresh
  void _onSessionChanged(User? user) {
    if (user != null) {
      user.getIdToken().then((token) {
        GetIt.I<NetworkManager>().token = token;
        if (mounted) {
          context.goNamed(AppRoute.home.name);
        }
      });
      return;
    }
    context.goNamed(AppRoute.login.name);
  }
}
