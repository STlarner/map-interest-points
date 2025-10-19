import "package:flutter/material.dart";

class TodoFeatureAlertDialog extends StatelessWidget {
  const TodoFeatureAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Feature not available"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Text(
            "This feature is not available yet, stay tuned for updates!",
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok, go back"),
            ),
          ),
        ],
      ),
    );
  }
}
