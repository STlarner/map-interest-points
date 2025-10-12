import "dart:io";

import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_color_scheme_extension.dart";

import "../../../dependency_injection/app_repository.dart";
import "../../../models/interest_point_model.dart";
import "../../../notifiers/progress_indicator_notifier.dart";
import "../../../notifiers/trip_detail_notifier.dart";
import "../../extensions/ui_context_extension.dart";

class InterestPointBottomSheet extends StatefulWidget {
  const InterestPointBottomSheet({super.key, required this.interestPoint});

  final InterestPointModel interestPoint;

  @override
  State<InterestPointBottomSheet> createState() =>
      _InterestPointBottomSheetState();
}

class _InterestPointBottomSheetState extends State<InterestPointBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> editModeNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    _titleController.text = widget.interestPoint.title;
    _descriptionController.text = widget.interestPoint.description;
    _dateController.text = widget.interestPoint.date.eEEEdMMMMy;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreatingNewInterestPoint =
        context.read<TripDetailNotifier>().draftInterestPoint ==
        widget.interestPoint;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
          left: 24,
          right: 24,
          top: 16,
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: editModeNotifier,
          builder: (context, isEditModeEnabled, child) {
            return Column(
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
                if (!isCreatingNewInterestPoint && !isEditModeEnabled)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(widget.interestPoint.title),
                        subtitle: Text(widget.interestPoint.description),
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          const Icon(Icons.calendar_month, size: 20),
                          Text(widget.interestPoint.date.eEEEdMMMMy),
                          const Spacer(),
                          Chip(
                            label: Text(
                              widget.interestPoint.visited
                                  ? "Visited"
                                  : "To visit",
                            ),
                            labelStyle: TextStyle(
                              color: context.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => openDefaultMap(
                          latitude:
                              widget.interestPoint.coordinates.latLng.latitude,
                          longitude:
                              widget.interestPoint.coordinates.latLng.longitude,
                          label: widget.interestPoint.title,
                        ),
                        label: const Text("Open location on map"),
                        icon: const Icon(Icons.location_pin),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("Close"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                editModeNotifier.value = true;
                              },
                              child: const Text("Edit"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (isCreatingNewInterestPoint || isEditModeEnabled)
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 16,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          autocorrect: false,
                          autofocus: isEditModeEnabled,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Enter a valid title"
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            hintText: "Enter the point of interest title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          minLines: 1,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Enter a valid description"
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            hintText: "Enter the point of interest description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _dateController,
                          maxLines: 3,
                          minLines: 1,
                          autocorrect: false,
                          readOnly: true,
                          canRequestFocus: false,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Enter a valid date"
                              : null,
                          onTap: () => _showDatePicker(context),
                          decoration: const InputDecoration(
                            labelText: "Date",
                            hintText: "Enter the interest point date",
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
                                onPressed: () {
                                  /// if edit mode is enabled exit it
                                  if (isEditModeEnabled) {
                                    editModeNotifier.value = false;
                                    return;
                                  }

                                  /// if in creation mode, pop the screen
                                  context.pop();
                                },
                              ),
                            ),
                            Expanded(
                              child: FilledButton(
                                child: const Text("Save"),
                                onPressed: () {
                                  final notifier = context
                                      .read<TripDetailNotifier>();
                                  if (_formKey.currentState?.validate() ==
                                      false) {
                                    return;
                                  }

                                  widget.interestPoint.title =
                                      _titleController.text;
                                  widget.interestPoint.description =
                                      _descriptionController.text;
                                  widget.interestPoint.date = _dateController
                                      .text
                                      .toDateTime(DateFormatUtils.eEEEdMMMMy);

                                  /// in this case we are creating a new interest point
                                  if (notifier.draftInterestPoint ==
                                      widget.interestPoint) {
                                    context
                                        .read<ProgressIndicatorNotifier>()
                                        .show();
                                    GetIt.I<AppRepository>()
                                        .addInterestPoint(
                                          notifier.trip,
                                          widget.interestPoint,
                                        )
                                        .whenComplete(() {
                                          if (context.mounted) {
                                            context
                                                .read<
                                                  ProgressIndicatorNotifier
                                                >()
                                                .hide();
                                          }
                                        })
                                        .then((point) {
                                          notifier
                                              .promoteDraftInterestPointToExisting(
                                                point.id,
                                              );
                                          if (context.mounted) {
                                            context.pop();
                                          }
                                        })
                                        .catchError((dynamic error) {
                                          if (context.mounted) {
                                            context.showErrorBanner(
                                              error.toString(),
                                            );
                                          }
                                        });
                                    return;
                                  }

                                  /// else we are updating an existing one
                                  context
                                      .read<ProgressIndicatorNotifier>()
                                      .show();
                                  GetIt.I<AppRepository>()
                                      .updateInterestPoint(
                                        notifier.trip,
                                        widget.interestPoint,
                                      )
                                      .then((_) {
                                        editModeNotifier.value = false;
                                        notifier.updateInterestPoints();
                                      })
                                      .whenComplete(() {
                                        if (context.mounted) {
                                          context
                                              .read<ProgressIndicatorNotifier>()
                                              .hide();
                                        }
                                      })
                                      .catchError((dynamic error) {
                                        if (context.mounted) {
                                          context.showErrorBanner(
                                            error.toString(),
                                          );
                                        }
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final tripNotifier = context.read<TripDetailNotifier>();
    DateTime? initialDate;

    try {
      initialDate = _dateController.text.toDateTime(DateFormatUtils.eEEEdMMMMy);
    } catch (_) {
      initialDate = tripNotifier.trip.startDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: tripNotifier.trip.startDate,
      lastDate: tripNotifier.trip.endDate,
    );

    if (pickedDate != null) {
      final String formattedDate = pickedDate.eEEEdMMMMy;
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  Future<void> openDefaultMap({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final encodedLabel = Uri.encodeComponent(label ?? "");
    try {
      var launched = false;

      if (Platform.isIOS) {
        // Try Apple Maps app first
        final appleMaps = Uri.parse(
          "maps://?ll=$latitude,$longitude&q=$encodedLabel",
        );
        if (await canLaunchUrl(appleMaps)) {
          launched = await launchUrl(
            appleMaps,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Optionally try Google Maps app if installed
          final googleMaps = Uri.parse(
            "comgooglemaps://?center=$latitude,$longitude&q=$encodedLabel",
          );
          if (await canLaunchUrl(googleMaps)) {
            launched = await launchUrl(
              googleMaps,
              mode: LaunchMode.externalApplication,
            );
          }
        }
      } else if (Platform.isAndroid) {
        // Prefer geo: on Android
        final geo = Uri.parse("geo:$latitude,$longitude?q=$encodedLabel");
        if (await canLaunchUrl(geo)) {
          launched = await launchUrl(geo, mode: LaunchMode.externalApplication);
        }
      }

      if (!launched && mounted) {
        context.showErrorBanner(
          "Cannot launch map application, check if you have one installed",
        );
      }
    } catch (e) {
      if (mounted) {
        context.showErrorBanner(e.toString());
      }
    }
  }
}
