import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../../../../core/widgets/form/app_phone_field.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../features/profile/data/models/profile_model.dart';
import '../cubit/personal_data_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.handleGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "choose_image_source".tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.authTitleColor,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'gallery'.tr(),
                    color: AppColors.primary,
                    bgColor: AppColors.primaryLight,
                    onTap: () {
                      context.pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'camera'.tr(),
                    color: AppColors.primary,
                    bgColor: AppColors.primaryLight,
                    onTap: () {
                      context.pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 32.w),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.authSectionTitleColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: tr('personal_data')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                _nameController.text = state.user.name;
                _phoneController.text = state.user.phone ?? "";
              }
            },
          ),
          BlocListener<PersonalDataCubit, PersonalDataState>(
            listener: (context, state) {
              if (state is PersonalDataSuccess) {
                // Update locally immediately instead of waiting for a network request
                context.read<ProfileCubit>().updateLocalProfile(state.user);
                // ✅ Fix 3.7: AppSnackBar for consistent success feedback
                AppSnackBar.showSuccess(context, "updated_successfully".tr());
                context.pop();
              } else if (state is PersonalDataError) {
                AppSnackBar.showError(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const AppLoadingIndicator();
            }

            if (state is ProfileError) {
              return AppErrorState(
                message: state.message,
                onRetry: () => context.read<ProfileCubit>().getProfile(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatarSection(
                      state is ProfileLoaded ? state.user : null,
                    ),
                    SizedBox(height: 32.h),
                    _buildTextFieldLabel("name".tr()),
                    AppTextFormField(
                      controller: _nameController,
                      hintText: "enter_name".tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "name_required".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildTextFieldLabel("phone_number".tr()),
                    AppPhoneField(
                      controller: _phoneController,
                      hintText: "phone_number".tr(),
                      maxLength: 11,
                      enabled: false,
                    ),
                    SizedBox(height: 24.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection(ProfileModel? user) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : (user?.image != null ? NetworkImage(user!.image!) : null)
                        as ImageProvider?,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: _imageFile == null && user?.image == null
                  ? Icon(Icons.person, size: 50.w, color: AppColors.primary)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImageSourceActionSheet,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 20.w,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.authTitleColor,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<PersonalDataCubit, PersonalDataState>(
      builder: (context, state) {
        return AppTextButton(
          buttonText: tr('save'),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          isLoading: state is PersonalDataLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<PersonalDataCubit>().updateProfile(
                name: _nameController.text,
                imagePath: _imageFile?.path,
              );
            }
          },
        );
      },
    );
  }
}
