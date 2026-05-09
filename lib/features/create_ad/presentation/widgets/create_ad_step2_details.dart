import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../../data/models/brand_model.dart';
import '../cubit/create_ad_cubit.dart';
import '../cubit/ad_category_selection_cubit.dart';
import '../cubit/ad_category_selection_state.dart';
import 'brand_selector_field.dart';
import 'ad_purpose_selector.dart';
import 'location_picker_field.dart';

class CreateAdStep2Details extends StatefulWidget {
  const CreateAdStep2Details({super.key});

  @override
  State<CreateAdStep2Details> createState() => CreateAdStep2DetailsState();
}

class CreateAdStep2DetailsState extends State<CreateAdStep2Details>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _priceController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  String? _purpose;
  BrandModel? _selectedBrand;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final draft = context.read<CreateAdCubit>().state;
    _priceController = TextEditingController(text: draft.price);
    _addressController = TextEditingController(text: draft.address ?? '');
    _areaController = TextEditingController(text: draft.area ?? '');
    _latController = TextEditingController(text: draft.lat ?? '');
    _lngController = TextEditingController(text: draft.lng ?? '');
    _purpose = draft.purpose;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final catState = context.read<AdCategorySelectionCubit>().state;
      final categoryType = catState.deepestCategory?.type;

      if (categoryType == 'vehicle' && _selectedBrand == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('please_choose_brand'))));
        return false;
      }
      if ((categoryType == 'real_estate' || categoryType == 'vehicle') &&
          _purpose == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('please_choose_purpose'))));
        return false;
      }

      context.read<CreateAdCubit>().saveStep2Data(
        price: _priceController.text.trim(),
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        area: _areaController.text.trim().isNotEmpty
            ? _areaController.text.trim()
            : null,
        lat: _latController.text.trim().isNotEmpty
            ? _latController.text.trim()
            : null,
        lng: _lngController.text.trim().isNotEmpty
            ? _lngController.text.trim()
            : null,
        purpose: _purpose,
        brandId: _selectedBrand?.id,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AdCategorySelectionCubit, AdCategorySelectionState>(
      builder: (context, catState) {
        final categoryType = catState.deepestCategory?.type;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Text(
                  tr('additional_data'),
                  style: AppTextStyles.font20BlackBold,
                ),
                SizedBox(height: 8.h),
                Text(
                  tr('additional_data_subtitle'),
                  style: AppTextStyles.font14GreyRegular,
                ),
                SizedBox(height: 24.h),

                if (categoryType == 'real_estate') ...[
                  LocationPickerField(
                    latController: _latController,
                    lngController: _lngController,
                    addressController: _addressController,
                  ),
                  SizedBox(height: 16.h),

                  AppTextFormField(
                    labelText: tr('area_label'),
                    hintText: tr('area_hint'),
                    controller: _areaController,
                    validator: (v) => v!.isEmpty ? tr('field_required') : null,
                    keyboardType: TextInputType.number,
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
                  ),
                  SizedBox(height: 16.h),
                  AdPurposeSelector(
                    selectedPurpose: _purpose,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _purpose = val;
                        });
                      }
                    },
                  ),
                ] else if (categoryType == 'vehicle') ...[
                  BrandSelectorField(
                    selectedBrand: _selectedBrand,
                    brands: catState.brands,
                    isLoading: catState.isBrandsLoading,
                    onChanged: (brand) {
                      setState(() {
                        _selectedBrand = brand;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  AdPurposeSelector(
                    selectedPurpose: _purpose,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _purpose = val;
                        });
                      }
                    },
                  ),
                ],

                SizedBox(height: 16.h),
                AppTextFormField(
                  labelText: tr('price_label'),
                  hintText: tr('price_hint'),
                  controller: _priceController,
                  validator: (v) => v!.isEmpty ? tr('field_required') : null,
                  keyboardType: TextInputType.number,
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
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
