import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;
  final TextInputType? keyboardType;
  final String? labelText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool hideErrorText;
  final int? maxLines;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.keyboardType,
    this.labelText,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.hideErrorText = false,
    this.maxLines,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: AppTextStyles.font16BlackMedium),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            focusedBorder:
                focusedBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
            enabledBorder:
                enabledBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.fieldBorder,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            hintText: hintText,
            suffixIcon: suffixIcon,
            suffixIconConstraints: suffixIconConstraints,
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
            fillColor: backgroundColor ?? AppColors.white,
            filled: true,
            errorStyle: hideErrorText
                ? const TextStyle(height: 0, fontSize: 0)
                : null,
          ),
          maxLines: maxLines ?? 1,
          obscureText: isObscureText ?? false,
          style: inputTextStyle ?? AppTextStyles.font14BlackRegular,
          validator: (value) {
            return validator(value);
          },
          keyboardType: keyboardType,
          onChanged: onChanged,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }
}
