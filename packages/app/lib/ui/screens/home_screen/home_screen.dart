import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/session_notifier.dart";
import "../../../router/app_routes.dart";
import "../../widgets/plan_card_widget.dart";

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [PlanCardWidget(), PlanCardWidget(), PlanCardWidget()],
          ),
        ),
      ),
    );
  }
}
