import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_color_scheme_extension.dart";

import "../../../notifiers/async_state.dart";
import "../../../notifiers/trip_detail_notifier.dart";
import "../../extensions/input_decoration_extension.dart";
import "../../widgets/appbar_circle_button.dart";

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    final notifier = context.read<TripDetailNotifier>();
    _searchController.text = notifier.mapSearchQuery ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Consumer<TripDetailNotifier>(
      builder: (context, tripNotifier, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: lightMode
                  ? Brightness.dark
                  : Brightness.light,
              statusBarBrightness: lightMode
                  ? Brightness.light
                  : Brightness.dark,
            ),
            title: TextField(
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              controller: _searchController,
              focusNode: _focusNode,
              onSubmitted: (value) =>
                  context.read<TripDetailNotifier>().mapSearch(value),
              decoration: InputDecoration(
                hintText: "Search here...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    tripNotifier.clearMapSearch();
                  },
                ),
              ).withoutBorder(fillColor: context.colorScheme.tertiaryContainer),
            ),
            leading: AppBarCircleButton(
              icon: Icons.close,
              foregroundColor: context.colorScheme.onTertiaryContainer,
              backgroundColor: context.colorScheme.tertiaryContainer,
              onTap: () => context.pop(),
            ),
          ),
          body: tripNotifier.mapSearchStatus == AsyncStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: context.colorScheme.secondary),
                  ),
                  itemCount: tripNotifier.mapSearchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tripNotifier.mapSearchResults[index].name!),
                      subtitle: Text(
                        tripNotifier
                            .mapSearchResults[index]
                            .address!
                            .formattedAddress,
                      ),
                      onTap: () {
                        final interestPoint = tripNotifier.buildInterestPoint(
                          tripNotifier.mapSearchResults[index],
                        );
                        tripNotifier.addDraftInterestPoint(interestPoint);
                        tripNotifier.mapSearchQuery = interestPoint.title;
                        context.pop(interestPoint);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
