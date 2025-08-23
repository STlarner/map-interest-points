import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/session_notifier.dart";
import "../../../router/app_routes.dart";
import "../../images/app_images.dart";
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
            children: [
              PlanCardWidget(
                planTitle: "Tokyo, Japan",
                planDescription:
                    "A two week trip to Tokyo and nearby cities like Osaka and Kyoto.",
                planImagePath: AppImages.tokyoSigns,
                planStartDate: DateTime(2023, 11, 02),
                planEndDate: DateTime(2023, 11, 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
