import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'create_ad_dropdown_field.dart';

class AdPurposeSelector extends StatelessWidget {
  final String? selectedPurpose;
  final ValueChanged<String?> onChanged;

  const AdPurposeSelector({
    super.key,
    required this.selectedPurpose,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CreateAdDropdownField<String>(
      label: tr('purpose_with_type'),
      hint: tr('choose_purpose'),
      value: selectedPurpose,
      items: const ['sale', 'rent'],
      itemLabel: (p) => p == 'sale' ? tr('sale') : tr('rent'),
      onChanged: onChanged,
    );
  }
}
