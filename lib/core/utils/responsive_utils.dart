import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isWideScreen(BoxConstraints constraints) =>
      constraints.maxWidth > 600;

  static double getMaxContentWidth(BoxConstraints constraints) {
    return isWideScreen(constraints) ? 450 : constraints.maxWidth;
  }

  static EdgeInsets getContentPadding(bool isWideScreen) {
    return EdgeInsets.symmetric(
      horizontal: isWideScreen ? 48.0 : 24.0,
      vertical: 24.0,
    );
  }

  static EdgeInsets getInnerPadding(bool isWideScreen) {
    return isWideScreen ? const EdgeInsets.all(32.0) : EdgeInsets.zero;
  }

  static BoxDecoration? getContainerDecoration(
    bool isWideScreen,
    BuildContext context,
  ) {
    if (!isWideScreen) return null;

    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static double getSpacing(bool isWideScreen, SpacingType type) {
    switch (type) {
      case SpacingType.top:
        return isWideScreen ? 32.0 : 24.0;
      case SpacingType.titleGap:
        return isWideScreen ? 16.0 : 8.0;
      case SpacingType.contentGap:
        return isWideScreen ? 48.0 : 32.0;
      case SpacingType.fieldGap:
        return 16.0;
      case SpacingType.smallGap:
        return 8.0;
      case SpacingType.mediumGap:
        return 24.0;
    }
  }
}

enum SpacingType { top, titleGap, contentGap, fieldGap, smallGap, mediumGap }
