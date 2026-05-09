import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../ads/domain/entities/ad_details_entity.dart';
import '../../../create_ad/data/models/brand_model.dart';
import '../widgets/edit_ad_section_header.dart';
import '../widgets/edit_ad_image_picker_grid.dart';
import '../widgets/edit_ad_dynamic_fields_section.dart';
import '../widgets/edit_ad_basic_info_section.dart';
import '../widgets/edit_ad_submit_button.dart';
import '../cubit/edit_ad_state.dart';

class EditAdBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AdDetailsEntity ad;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController addressController;
  final TextEditingController areaController;
  final String? selectedPurpose;
  final BrandModel? selectedBrand;
  final List<AdImageEntity> existingImages;
  final List<File> newImages;
  final EditAdState state;
  final VoidCallback onSubmit;
  final VoidCallback onPickImage;
  final Function(int) onRemoveExisting;
  final Function(int) onRemoveNew;
  final Function(String?) onPurposeChanged;
  final Function(BrandModel?) onBrandChanged;

  const EditAdBody({
    super.key,
    required this.formKey,
    required this.ad,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.addressController,
    required this.areaController,
    required this.selectedPurpose,
    required this.selectedBrand,
    required this.existingImages,
    required this.newImages,
    required this.state,
    required this.onSubmit,
    required this.onPickImage,
    required this.onRemoveExisting,
    required this.onRemoveNew,
    required this.onPurposeChanged,
    required this.onBrandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: Column(
              children: [
                EditAdBasicInfoSection(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  priceController: priceController,
                ),
                EditAdDynamicFieldsSection(
                  categoryType: ad.category?.type,
                  addressController: addressController,
                  areaController: areaController,
                  selectedPurpose: selectedPurpose,
                  selectedBrand: selectedBrand,
                  onPurposeChanged: onPurposeChanged,
                  onBrandChanged: onBrandChanged,
                ),
                const EditAdSectionHeader(
                  title: 'ad_images',
                  icon: Icons.image_outlined,
                ),
                EditAdImagePickerGrid(
                  existingImages: existingImages,
                  newImages: newImages,
                  onPickImage: onPickImage,
                  onRemoveExisting: onRemoveExisting,
                  onRemoveNew: onRemoveNew,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
        EditAdSubmitButton(
          isLoading: state is EditAdLoading,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
