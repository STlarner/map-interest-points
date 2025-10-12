import "package:flutter/material.dart";
import "package:ui/ui.dart";

class FloatingBottomNavigationBar extends StatefulWidget {
  const FloatingBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.onCenterButtonTap,
  });

  final ValueChanged<int>? onTap;
  final int currentIndex;
  final VoidCallback? onCenterButtonTap;

  @override
  State<FloatingBottomNavigationBar> createState() =>
      _FloatingBottomNavigationBarState();
}

class _FloatingBottomNavigationBarState
    extends State<FloatingBottomNavigationBar> {
  late final ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    _currentIndexNotifier = ValueNotifier<int>(widget.currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: ShapeDecoration(
            color: context.colorScheme.primaryContainer,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        currentIndex == 0 ? Icons.home : Icons.home_outlined,
                      ),
                      color: context.colorScheme.onPrimaryContainer,
                      onPressed: () {
                        _currentIndexNotifier.value = 0;
                        widget.onTap?.call(0);
                      },
                    ),
                    Hero(
                      tag: "bottom-bar-center-button",
                      child: ElevatedButton(
                        onPressed: widget.onCenterButtonTap,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor:
                              context.colorScheme.onPrimaryContainer,
                        ),
                        child: Icon(
                          Icons.add,
                          color: context.colorScheme.surface,
                          size: 28,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        currentIndex == 1
                            ? Icons.pin_drop_rounded
                            : Icons.pin_drop_outlined,
                      ),
                      color: context.colorScheme.onPrimaryContainer,
                      onPressed: () {
                        _currentIndexNotifier.value = 1;
                        widget.onTap?.call(1);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
