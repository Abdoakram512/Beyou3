import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../cubit/create_ad_cubit.dart';
import '../cubit/ad_category_selection_cubit.dart';
import 'hierarchical_category_selector.dart';
import 'create_ad_text_area.dart';

class CreateAdStep1BasicData extends StatefulWidget {
  const CreateAdStep1BasicData({super.key});

  @override
  State<CreateAdStep1BasicData> createState() => CreateAdStep1BasicDataState();
}

class CreateAdStep1BasicDataState extends State<CreateAdStep1BasicData>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final draft = context.read<CreateAdCubit>().state;
    _titleController = TextEditingController(text: draft.title);
    _descriptionController = TextEditingController(text: draft.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final catState = context.read<AdCategorySelectionCubit>().state;
    final deepestCategory = catState.deepestCategory;

    if (deepestCategory == null) {
      // ✅ Fix 3.7: AppSnackBar for consistent validation feedback
      AppSnackBar.showError(context, tr('please_choose_category'));
      return false;
    }

    if (catState.subcategoriesMap[catState.selectedCategoryPath.length] !=
            null &&
        catState
            .subcategoriesMap[catState.selectedCategoryPath.length]!
            .isNotEmpty &&
        deepestCategory.hasChildren) {
      AppSnackBar.showError(context, tr('please_complete_subcategory'));
      return false;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateAdCubit>().saveStep1Data(
        categoryId: deepestCategory.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(tr('basic_data'), style: AppTextStyles.font20BlackBold),
            SizedBox(height: 8.h),
            Text(
              tr('basic_data_subtitle'),
              style: AppTextStyles.font14GreyRegular,
            ),
            SizedBox(height: 24.h),

            const HierarchicalCategorySelector(),
            SizedBox(height: 16.h),

            AppTextFormField(
              labelText: tr('ad_title'),
              hintText: tr('ad_title_example'),
              controller: _titleController,
              validator: (v) => v!.isEmpty ? tr('field_required') : null,
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

            CreateAdTextArea(
              label: tr('ad_description_label'),
              hintText: tr('ad_description_label'),
              controller: _descriptionController,
              validator: (v) => v!.isEmpty ? tr('field_required') : null,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
