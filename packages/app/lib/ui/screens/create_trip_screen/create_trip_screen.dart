import "package:flutter/material.dart";

import "../../widgets/appbar_circle_button.dart";

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new trip"),
        leading: AppBarCircleButton(
          padding: const EdgeInsets.only(left: 16),
          icon: Icons.close,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Hero(
        tag: "bottom-bar-center-button",
        child: Scaffold(body: Placeholder()),
      ),
    );
  }
}
