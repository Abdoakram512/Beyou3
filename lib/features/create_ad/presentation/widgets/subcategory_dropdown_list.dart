import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../cubit/ad_category_selection_cubit.dart';
import '../cubit/ad_category_selection_state.dart';
import 'category_dropdown.dart';

class SubcategoryDropdownList extends StatelessWidget {
  final AdCategorySelectionState adState;
  final AdCategorySelectionCubit cubit;

  const SubcategoryDropdownList({
    super.key,
    required this.adState,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    int level = 1;
    while (true) {
      final isLoading = adState.loadingLevels.contains(level);
      final items = adState.subcategoriesMap[level];

      if (!isLoading && (items == null || items.isEmpty)) break;

      final selectedAtThisLevel = adState.selectedCategoryPath.length > level
          ? adState.selectedCategoryPath[level]
          : null;

      widgets.add(SizedBox(height: 12.h));
      widgets.add(
        CategoryDropdown(
          label: _labelForLevel(level),
          hint: tr('choose_subcategory'),
          items: items ?? [],
          isLoading: isLoading,
          selectedItem: selectedAtThisLevel,
          onChanged: (cat) {
            if (cat != null) cubit.selectCategoryAtLevel(level, cat);
          },
        ),
      );

      if (selectedAtThisLevel == null) break;
      level++;
    }
    return Column(children: widgets);
  }

  String _labelForLevel(int level) {
    switch (level) {
      case 1:
        return tr('subcategory');
      case 2:
        return tr('classification');
      default:
        return tr('subcategory_with_level', args: [level.toString()]);
    }
  }
}
