import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import 'edit_ad_section_header.dart';

class EditAdBasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;

  const EditAdBasicInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditAdSectionHeader(
          title: 'basic_info',
          icon: Icons.article_outlined,
        ),
        AppTextFormField(
          labelText: tr('ad_title'),
          hintText: tr('ad_title_hint'),
          controller: titleController,
          validator: (v) => v!.isEmpty ? tr('field_required') : null,
        ),
        SizedBox(height: 16.h),
        AppTextFormField(
          labelText: tr('ad_description'),
          hintText: tr('ad_description_hint'),
          controller: descriptionController,
          maxLines: 4,
          validator: (v) => v!.isEmpty ? tr('field_required') : null,
        ),
        SizedBox(height: 16.h),
        AppTextFormField(
          labelText: tr('price_label'),
          hintText: tr('price_hint'),
          controller: priceController,
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? tr('field_required') : null,
          prefixIcon: const Icon(Icons.attach_money, color: AppColors.greyText),
        ),
      ],
    );
  }
}
