import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsMessageForm extends StatefulWidget {
  const ContactUsMessageForm({super.key});

  @override
  State<ContactUsMessageForm> createState() => _ContactUsMessageFormState();
}

class _ContactUsMessageFormState extends State<ContactUsMessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(tr('subject')),
          AppTextFormField(
            controller: _subjectController,
            hintText: tr('enter_subject'),
            validator: (value) {
              if (value == null || value.isEmpty) return tr('subject_required');
              return null;
            },
          ),
          SizedBox(height: 16.h),
          _buildLabel(tr('message')),
          AppTextFormField(
            controller: _messageController,
            hintText: tr('enter_message'),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) return tr('message_required');
              return null;
            },
          ),
          SizedBox(height: 32.h),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.authSectionTitleColor,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
      builder: (context, state) {
        return AppTextButton(
          buttonText: tr('send_message'),
          textStyle: AppTextStyles.font18WhiteSemiBold,
          isLoading: state is ContactUsLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<ContactUsCubit>().sendContactMessage(
                    subject: _subjectController.text,
                    message: _messageController.text,
                  );
            }
          },
        );
      },
    );
  }
}
