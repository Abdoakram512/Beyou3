import 'dart:io';
import 'package:beyou3/core/widgets/common/custom_app_bar.dart';
import 'package:beyou3/features/create_ad/presentation/cubit/ad_category_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../../../ads/domain/entities/ad_details_entity.dart';
import '../../data/models/edit_ad_request_model.dart';
import '../cubit/edit_ad_cubit.dart';
import '../cubit/edit_ad_state.dart';
import '../../../create_ad/presentation/cubit/ad_category_selection_cubit.dart';
import '../../../create_ad/data/models/brand_model.dart';
import '../widgets/edit_ad_body.dart';

class EditAdScreen extends StatefulWidget {
  final AdDetailsEntity ad;
  const EditAdScreen({super.key, required this.ad});

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  String? _selectedPurpose;
  BrandModel? _selectedBrand;

  final List<AdImageEntity> _existingImages = [];
  final List<String> _deletedImageIds = [];
  final List<File> _newImages = [];

  final _imagePicker = getIt<ImagePickerService>();

  @override
  void initState() {
    super.initState();
    _initControllers();
    _existingImages.addAll(widget.ad.images);
    if (widget.ad.category?.type == 'vehicle') {
      context.read<AdCategorySelectionCubit>().getBrands();
    }
  }

  void _initControllers() {
    _titleController = TextEditingController(text: widget.ad.title);
    _descriptionController = TextEditingController(
      text: widget.ad.description ?? '',
    );
    _priceController = TextEditingController(text: widget.ad.price.toString());
    _addressController = TextEditingController(
      text: widget.ad.location?.address ?? '',
    );
    _areaController = TextEditingController(text: widget.ad.area ?? '');
    _latController = TextEditingController(
      text: widget.ad.location?.lat?.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: widget.ad.location?.lng?.toString() ?? '',
    );
    _selectedPurpose = widget.ad.purpose?.toLowerCase();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = EditAdRequestModel(
        adId: widget.ad.id,
        categoryId: widget.ad.category?.id ?? 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _priceController.text.trim(),
        images: _newImages,
        deletedImageIds: _deletedImageIds,
        address: _addressController.text.trim(),
        lat: _latController.text.trim(),
        lng: _lngController.text.trim(),
        area: _areaController.text.trim(),
        purpose: _selectedPurpose ?? 'sale',
        brandId: _selectedBrand?.id.toString() ?? '',
      );
      context.read<EditAdCubit>().editAd(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: tr('edit_ad')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EditAdCubit, EditAdState>(
            listener: (context, state) {
              if (state is EditAdSuccess) {
                // ✅ Fix 3.7: AppSnackBar for consistent success feedback
                AppSnackBar.showSuccess(context, tr('ad_updated_successfully'));
                context.pop(true);
              } else if (state is EditAdFailure) {
                AppSnackBar.showError(context, state.message);
              }
            },
          ),
          BlocListener<AdCategorySelectionCubit, AdCategorySelectionState>(
            listener: (context, state) {
              if (_selectedBrand == null &&
                  state.brands.isNotEmpty &&
                  widget.ad.brand != null) {
                try {
                  final matchingBrand = state.brands.firstWhere(
                    (b) => b.name == widget.ad.brand,
                  );
                  setState(() => _selectedBrand = matchingBrand);
                } catch (_) {}
              }
            },
          ),
        ],
        child: BlocBuilder<EditAdCubit, EditAdState>(
          builder: (context, state) {
            return EditAdBody(
              formKey: _formKey,
              ad: widget.ad,
              titleController: _titleController,
              descriptionController: _descriptionController,
              priceController: _priceController,
              addressController: _addressController,
              areaController: _areaController,
              selectedPurpose: _selectedPurpose,
              selectedBrand: _selectedBrand,
              existingImages: _existingImages,
              newImages: _newImages,
              state: state,
              onSubmit: _submit,
              onPickImage: () async {
                final file = await _imagePicker.pickFromGallery();
                if (file != null) setState(() => _newImages.add(file));
              },
              onRemoveExisting: (idx) => setState(() {
                _deletedImageIds.add(_existingImages[idx].id.toString());
                _existingImages.removeAt(idx);
              }),
              onRemoveNew: (idx) => setState(() => _newImages.removeAt(idx)),
              onPurposeChanged: (val) => setState(() => _selectedPurpose = val),
              onBrandChanged: (brand) => setState(() => _selectedBrand = brand),
            );
          },
        ),
      ),
    );
  }
}
