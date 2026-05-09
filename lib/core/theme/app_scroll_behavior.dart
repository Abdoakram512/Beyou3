import 'package:flutter/material.dart';

/// Global scroll behavior that applies smooth iOS-style bouncing physics
/// on all platforms and removes the Android overscroll glow indicator.
class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Remove the Android overscroll glow effect for a cleaner look.
    return child;
  }
}
