import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateAdDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CreateAdDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.font14BlackRegular),
        SizedBox(height: 8.h),
        DropdownButtonFormField<T>(
          value: value,
          alignment: Alignment.center,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.greyText,
            size: 24.w,
          ),
          hint: Center(
            child: Text(
              hint,
              style: AppTextStyles.font14GreyRegular,
              textAlign: TextAlign.center,
            ),
          ),
          isExpanded: true,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              alignment: Alignment.center,
              child: Text(
                itemLabel(item),
                style: AppTextStyles.font14BlackRegular,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Padding(
              padding: EdgeInsets.all(8.w),
              child: SvgPicture.asset(
                AppIcons.star,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  AppColors.greyText,
                  BlendMode.srcIn,
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
          ),
        ),
      ],
    );
  }
}
