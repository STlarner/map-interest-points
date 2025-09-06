import "package:flutter/material.dart";
import "package:ui/extensions/context_extensions/context_color_scheme_extension.dart";

class CheckboxListCardTile extends StatefulWidget {
  const CheckboxListCardTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
    required this.subtitle,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final String title;
  final String subtitle;

  @override
  State<CheckboxListCardTile> createState() => _CheckboxListCardTileState();
}

class _CheckboxListCardTileState extends State<CheckboxListCardTile> {
  bool value = false;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: (bool? newValue) {
          setState(() {
            value = newValue!;
          });
        },
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
      ),
    );
  }
}
