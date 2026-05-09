import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/brand_model.dart';
import 'create_ad_dropdown_field.dart';

class BrandSelectorField extends StatelessWidget {
  final BrandModel? selectedBrand;
  final List<BrandModel> brands;
  final bool isLoading;
  final ValueChanged<BrandModel?> onChanged;

  const BrandSelectorField({
    super.key,
    required this.selectedBrand,
    required this.brands,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CreateAdDropdownField<BrandModel>(
      label: tr('brand'),
      hint: tr('choose_brand'),
      value: selectedBrand,
      items: brands,
      itemLabel: (b) => b.name,
      onChanged: onChanged,
    );
  }
}
