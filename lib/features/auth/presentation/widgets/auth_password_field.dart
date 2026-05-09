import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?) validator;
  final void Function(String)? onFieldSubmitted;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    required this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      isObscureText: isObscured,
      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            isObscured = !isObscured;
          });
        },
        icon: Icon(
          isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.grey,
        ),
      ),
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
