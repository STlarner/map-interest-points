import "package:flutter/material.dart";
import "package:ui/extensions/context_extensions/context_color_scheme_extension.dart";

class CheckboxListCardTile extends StatefulWidget {
  const CheckboxListCardTile({
    super.key,
    required this.value,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.showDeleteButton,
    this.onChanged,
    this.onTap,
    this.onDeleteTap,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final bool showDeleteButton;
  final String id;
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
      child: Row(
        children: [
          if (widget.showDeleteButton)
            IconButton(
              onPressed: widget.onDeleteTap,
              icon: const Icon(Icons.delete),
            ),
          Expanded(
            child: ListTile(
              title: Text(widget.title),
              subtitle: Text(widget.subtitle),
              onTap: widget.onTap,
              trailing: Checkbox(
                value: value,
                onChanged: (bool? newValue) {
                  setState(() => value = newValue!);
                  widget.onChanged?.call(newValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
