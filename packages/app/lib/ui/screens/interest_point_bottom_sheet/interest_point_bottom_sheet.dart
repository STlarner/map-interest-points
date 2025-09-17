import "package:flutter/material.dart";
import "package:ui/extensions/context_extensions/context_color_scheme_extension.dart";

class InterestPointBottomSheet extends StatefulWidget {
  const InterestPointBottomSheet({super.key});

  @override
  State<InterestPointBottomSheet> createState() =>
      _InterestPointBottomSheetState();
}

class _InterestPointBottomSheetState extends State<InterestPointBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          left: 24,
          right: 24,
          top: 16,
        ),
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Form(
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    controller: _titleController,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter a valid title"
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "Enter the trip title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter a valid description"
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Enter the trip description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: const Text("Cancel"),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          child: const Text("Save"),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
