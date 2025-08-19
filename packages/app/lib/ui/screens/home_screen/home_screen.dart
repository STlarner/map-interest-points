import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/session_notifier.dart";
import "../../../router/app_routes.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SessionNotifier>().logout();
              context.go(AppRoute.login.path);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
