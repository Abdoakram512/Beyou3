import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../cubit/ad_category_selection_cubit.dart';
import '../cubit/ad_category_selection_state.dart';
import 'category_dropdown.dart';
import 'subcategory_dropdown_list.dart';

class HierarchicalCategorySelector extends StatelessWidget {
  const HierarchicalCategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, catState) {
        List<CategoryEntity> rootCategories = [];
        bool rootLoading = catState is CategoriesLoading;

        if (catState is CategoriesLoaded) {
          rootCategories = catState.rootCategories;
        }

        return BlocBuilder<AdCategorySelectionCubit, AdCategorySelectionState>(
          builder: (context, adState) {
            final cubit = context.read<AdCategorySelectionCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryDropdown(
                  label: tr('main_category'),
                  hint: tr('choose_category'),
                  items: rootCategories,
                  isLoading: rootLoading,
                  selectedItem: adState.selectedCategoryPath.isNotEmpty
                      ? adState.selectedCategoryPath[0]
                      : null,
                  onChanged: (cat) {
                    if (cat != null) cubit.selectCategoryAtLevel(0, cat);
                  },
                ),
                SubcategoryDropdownList(adState: adState, cubit: cubit),
              ],
            );
          },
        );
      },
    );
  }
}
