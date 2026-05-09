import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../cubit/create_ad_cubit.dart';
import 'create_ad_image_picker.dart';
import 'image_source_bottom_sheet.dart';

class CreateAdStep3Images extends StatefulWidget {
  const CreateAdStep3Images({super.key});

  @override
  State<CreateAdStep3Images> createState() => CreateAdStep3ImagesState();
}

class CreateAdStep3ImagesState extends State<CreateAdStep3Images>
    with AutomaticKeepAliveClientMixin {
  File? _mainImage;
  final List<File?> _extraImages = List.filled(6, null);
  final _imagePicker = getIt<ImagePickerService>();
  bool _showExtraImagesError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final draft = context.read<CreateAdCubit>().state;
    _mainImage = draft.mainImage;
    for (int i = 0; i < draft.extraImages.length && i < 6; i++) {
      _extraImages[i] = draft.extraImages[i];
    }
  }

  bool validateAndSave() {
    if (_mainImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr('add_main_image'))));
      return false;
    }

    if (_extraImages.whereType<File>().isEmpty) {
      setState(() {
        _showExtraImagesError = true;
      });
      return false;
    }

    setState(() {
      _showExtraImagesError = false;
    });

    context.read<CreateAdCubit>().updateImages(
      mainImage: _mainImage,
      extraImages: _extraImages.whereType<File>().toList(),
    );
    return true;
  }

  Future<void> _pickImage({
    required bool isCamera,
    required bool isMain,
    int? index,
  }) async {
    final file = isCamera
        ? await _imagePicker.pickFromCamera()
        : await _imagePicker.pickFromGallery();

    if (file != null) {
      setState(() {
        if (isMain) {
          _mainImage = file;
        } else {
          _extraImages[index!] = file;
          _showExtraImagesError = false;
        }
      });
    }
  }

  void _showImageSourceSheet({required bool isMain, int? index}) {
    ImageSourceBottomSheet.show(
      context,
      onCameraTap: () {
        Navigator.pop(context);
        _pickImage(isCamera: true, isMain: isMain, index: index);
      },
      onGalleryTap: () {
        Navigator.pop(context);
        _pickImage(isCamera: false, isMain: isMain, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(tr('add_images'), style: AppTextStyles.font20BlackBold),
          SizedBox(height: 16.h),
          Text(tr('main_image_label'), style: AppTextStyles.font16BlackMedium),
          SizedBox(height: 8.h),
          CreateAdImagePicker(
            image: _mainImage,
            isMain: true,
            label: tr('add_main_image'),
            onTap: () => _showImageSourceSheet(isMain: true),
          ),
          SizedBox(height: 24.h),
          Text(tr('other_images'), style: AppTextStyles.font16BlackMedium),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: _showExtraImagesError
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: _showExtraImagesError
                    ? Colors.red.withValues(alpha: 0.5)
                    : Colors.blue.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _showExtraImagesError
                      ? Icons.error_outline
                      : Icons.info_outline,
                  color: _showExtraImagesError ? Colors.red : Colors.blue,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    tr('add_at_least_one_extra_image'),
                    style: AppTextStyles.font14BlackRegular.copyWith(
                      color: _showExtraImagesError
                          ? Colors.red
                          : Colors.blue[700],
                      fontWeight: _showExtraImagesError
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.5,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return CreateAdImagePicker(
                image: _extraImages[index],
                isMain: false,
                label: tr('add_image'),
                onTap: () => _showImageSourceSheet(isMain: false, index: index),
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
