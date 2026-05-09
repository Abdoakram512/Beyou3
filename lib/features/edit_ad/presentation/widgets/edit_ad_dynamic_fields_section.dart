import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../../../create_ad/presentation/widgets/ad_purpose_selector.dart';
import '../../../create_ad/presentation/widgets/brand_selector_field.dart';
import '../../../create_ad/presentation/cubit/ad_category_selection_cubit.dart';
import '../../../create_ad/presentation/cubit/ad_category_selection_state.dart';
import '../../../create_ad/data/models/brand_model.dart';
import 'edit_ad_section_header.dart';

class EditAdDynamicFieldsSection extends StatelessWidget {
  final String? categoryType;
  final TextEditingController addressController;
  final TextEditingController areaController;

  final String? selectedPurpose;
  final BrandModel? selectedBrand;
  final Function(String?) onPurposeChanged;
  final Function(BrandModel?) onBrandChanged;

  const EditAdDynamicFieldsSection({
    super.key,
    required this.categoryType,
    required this.addressController,
    required this.areaController,

    required this.selectedPurpose,
    required this.selectedBrand,
    required this.onPurposeChanged,
    required this.onBrandChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryType != 'real_estate' && categoryType != 'vehicle') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditAdSectionHeader(
          title: tr('additional_data'),
          icon: Icons.add_circle_outline,
        ),
        if (categoryType == 'real_estate') ...[
          AppTextFormField(
            labelText: tr('address_label'),
            hintText: tr('address_hint'),
            controller: addressController,
            validator: (v) => v!.isEmpty ? tr('field_required') : null,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            labelText: tr('area_label'),
            hintText: tr('area_hint'),
            controller: areaController,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? tr('field_required') : null,
          ),
          SizedBox(height: 16.h),
        ] else if (categoryType == 'vehicle') ...[
          BlocBuilder<AdCategorySelectionCubit, AdCategorySelectionState>(
            builder: (context, state) {
              return BrandSelectorField(
                selectedBrand: selectedBrand,
                brands: state.brands,
                isLoading: state.isBrandsLoading,
                onChanged: onBrandChanged,
              );
            },
          ),
        ],
        SizedBox(height: 16.h),
        AdPurposeSelector(
          selectedPurpose: selectedPurpose,
          onChanged: onPurposeChanged,
        ),
      ],
    );
  }
}
