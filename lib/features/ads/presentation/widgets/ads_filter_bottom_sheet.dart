import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';

class AdsFilterBottomSheet extends StatefulWidget {
  final String? initialPurpose;
  final num? initialMinPrice;
  final num? initialMaxPrice;
  final Function(String? purpose, num? minPrice, num? maxPrice) onApply;

  const AdsFilterBottomSheet({
    super.key,
    this.initialPurpose,
    this.initialMinPrice,
    this.initialMaxPrice,
    required this.onApply,
  });

  @override
  State<AdsFilterBottomSheet> createState() => _AdsFilterBottomSheetState();
}

class _AdsFilterBottomSheetState extends State<AdsFilterBottomSheet> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String? _selectedPurpose;

  @override
  void initState() {
    super.initState();
    _selectedPurpose = widget.initialPurpose;
    _minPriceController.text = widget.initialMinPrice?.toString() ?? '';
    _maxPriceController.text = widget.initialMaxPrice?.toString() ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('filter'), style: AppTextStyles.font20BlackBold),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPurpose = null;
                      _minPriceController.clear();
                      _maxPriceController.clear();
                    });
                  },
                  child: Text(
                    tr('reset'),
                    style: AppTextStyles.font14GreyRegular.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Purpose Selection
            Text(tr('purpose'), style: AppTextStyles.font16BlackSemiBold),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildPurposeChip(label: tr('all'), value: null),
                SizedBox(width: 10.w),
                _buildPurposeChip(label: tr('sale'), value: 'sale'),
                SizedBox(width: 10.w),
                _buildPurposeChip(label: tr('rent'), value: 'rent'),
              ],
            ),
            SizedBox(height: 24.h),

            // Price Range
            Text(tr('price_range'), style: AppTextStyles.font16BlackSemiBold),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _minPriceController,
                    hintText: tr('min_price'),
                    keyboardType: TextInputType.number,
                    validator: (val) => null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppTextFormField(
                    controller: _maxPriceController,
                    hintText: tr('max_price'),
                    keyboardType: TextInputType.number,
                    validator: (val) => null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final min = _parsePrice(_minPriceController.text);
                  final max = _parsePrice(_maxPriceController.text);
                  widget.onApply(_selectedPurpose, min, max);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  tr('apply'),
                  style: AppTextStyles.font16WhiteSemiBold,
                ),
              ),
            ),
            SizedBox(height: 45.h),
          ],
        ),
      ),
    );
  }

  num? _parsePrice(String text) {
    if (text.isEmpty) return null;
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    String normalized = text;
    for (int i = 0; i < arabic.length; i++) {
      normalized = normalized.replaceAll(arabic[i], english[i]);
    }
    normalized = normalized.replaceAll(RegExp(r'[\s,]'), '');
    return num.tryParse(normalized);
  }

  Widget _buildPurposeChip({required String label, required String? value}) {
    final isSelected = _selectedPurpose == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPurpose = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.font16WhiteSemiBold
              : AppTextStyles.font16BlackMedium,
        ),
      ),
    );
  }
}

// Static helper to show the bottom sheet
void showAdsFilterBottomSheet({
  required BuildContext context,
  String? initialPurpose,
  num? initialMinPrice,
  num? initialMaxPrice,
  required Function(String? purpose, num? minPrice, num? maxPrice) onApply,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AdsFilterBottomSheet(
      initialPurpose: initialPurpose,
      initialMinPrice: initialMinPrice,
      initialMaxPrice: initialMaxPrice,
      onApply: onApply,
    ),
  );
}
