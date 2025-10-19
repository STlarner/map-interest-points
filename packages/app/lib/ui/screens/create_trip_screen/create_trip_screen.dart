import "package:core/core.dart";
import "package:flutter/material.dart";

import "../../widgets/appbar_circle_button.dart";
import "../../widgets/todo_feature_alert_dialog.dart";

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "bottom-bar-center-button",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create a new trip"),
          leading: AppBarCircleButton(
            padding: const EdgeInsets.only(left: 16),
            icon: Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "Enter trip title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter a valid title"
                        : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Enter trip description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter a valid description"
                        : null,
                    maxLines: 3,
                    minLines: 1,
                  ),
                  TextFormField(
                    controller: startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Start Date",
                      hintText: "Select start date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => pickDate(
                      context: context,
                      controller: startDateController,
                      initialDate: startDate,
                      lastDate: endDate,
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Select a start date"
                        : null,
                  ),
                  TextFormField(
                    controller: endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "End Date",
                      hintText: "Select end date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => pickDate(
                      context: context,
                      controller: endDateController,
                      initialDate: endDate ?? startDate,
                      firstDate: startDate,
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Select an end date"
                        : null,
                  ),
                  FilledButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return const TodoFeatureAlertDialog();
                        },
                      );
                      //if (formKey.currentState?.validate() ?? false) {}
                    },
                    child: const Text("Create Trip"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickDate({
    required BuildContext context,
    required TextEditingController controller,
    required DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? effectiveInitialDate = initialDate;
    final now = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        effectiveInitialDate = DateTime.parse(controller.text);
      } catch (_) {
        effectiveInitialDate = initialDate ?? now;
      }
    } else {
      effectiveInitialDate = initialDate ?? now;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      final String formattedDate = pickedDate.eEEEdMMMMy;
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
}
