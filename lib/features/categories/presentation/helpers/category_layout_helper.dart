class CategoryLayoutHelper {
  /// Calculates the width for a category card based on a strict 3, 2, 2, 2 pattern.
  ///
  /// - index: The index of the item within the list.
  /// - totalWidth: The available width from LayoutBuilder constraints.
  /// - spacing: The horizontal spacing between items.
  /// - totalCount: Total number of items in the current section.
  static double calculateWidth({
    required int index,
    required double totalWidth,
    required double spacing,
    required int totalCount,
  }) {
    int patternIndex = index % 9;
    bool isLast = index == totalCount - 1;

    // Row starts: 0 (3-item), 3 (2-item), 5 (2-item), 7 (2-item)
    bool isRowStart =
        patternIndex == 0 ||
        patternIndex == 3 ||
        patternIndex == 5 ||
        patternIndex == 7;

    // Solo item fallback (Full Width)
    if (isLast && isRowStart) {
      return totalWidth;
    }

    if (patternIndex < 3) {
      // Row 1 (3 items): Indices 0, 1, 2
      // If we are at the start of a 3-item row and only 2 items are left, split 50/50
      if (patternIndex == 0 && index == totalCount - 2) {
        return (totalWidth - spacing) / 2;
      }
      if (patternIndex == 1 && isLast) {
        return (totalWidth - spacing) / 2;
      }
      return (totalWidth - (2 * spacing)) / 3;
    } else if (patternIndex == 3) {
      // Row 2: Large (Index 3)
      return (totalWidth - spacing) * 0.65;
    } else if (patternIndex == 4) {
      // Row 2: Small (Index 4)
      return (totalWidth - spacing) * 0.35;
    } else if (patternIndex == 5) {
      // Row 3: Medium 1 (Index 5)
      return (totalWidth - spacing) * 0.45;
    } else if (patternIndex == 6) {
      // Row 3: Medium 2 (Index 6)
      return (totalWidth - spacing) * 0.55;
    } else if (patternIndex == 7) {
      // Row 4: Small (Index 7)
      return (totalWidth - spacing) * 0.35;
    } else if (patternIndex == 8) {
      // Row 4: Large (Index 8)
      return (totalWidth - spacing) * 0.65;
    }

    return (totalWidth - spacing) / 2;
  }
}
