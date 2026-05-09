import 'package:beyou3/features/create_ad/presentation/screens/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LocationPickerField extends StatefulWidget {
  final TextEditingController latController;
  final TextEditingController lngController;
  final TextEditingController addressController;

  const LocationPickerField({
    super.key,
    required this.latController,
    required this.lngController,
    required this.addressController,
  });

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  bool _isGeocoding = false;

  bool get _hasLocation =>
      widget.latController.text.isNotEmpty &&
      widget.lngController.text.isNotEmpty;

  Future<void> _openPicker(BuildContext context) async {
    final double? currentLat = double.tryParse(widget.latController.text);
    final double? currentLng = double.tryParse(widget.lngController.text);

    final LatLng? result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLat: currentLat,
          initialLng: currentLng,
        ),
      ),
    );

    if (result != null) {
      widget.latController.text = result.latitude.toStringAsFixed(6);
      widget.lngController.text = result.longitude.toStringAsFixed(6);

      // Reverse geocoding - ØªØ¹Ø¨Ø¦Ø© Ø­Ù‚Ù„ Ø§Ù„Ø¹Ù†ÙˆØ§Ù† ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹
      setState(() => _isGeocoding = true);
      try {
        final placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final parts = <String>[
            if (place.street != null && place.street!.isNotEmpty) place.street!,
            if (place.subLocality != null && place.subLocality!.isNotEmpty)
              place.subLocality!,
            if (place.locality != null && place.locality!.isNotEmpty)
              place.locality!,
            if (place.administrativeArea != null &&
                place.administrativeArea!.isNotEmpty)
              place.administrativeArea!,
          ];
          widget.addressController.text = parts.join('ØŒ ');
        }
      } catch (_) {
        // ÙÙŠ Ø­Ø§Ù„Ø© ÙØ´Ù„ Ø§Ù„Ù€ geocodingØŒ Ø§Ù„Ø¹Ù†ÙˆØ§Ù† ÙŠÙØ¶Ù„ ÙØ§Ø¶ÙŠ
      } finally {
        setState(() => _isGeocoding = false);
      }
    }
  }

  void _clearLocation() {
    widget.latController.clear();
    widget.lngController.clear();
    widget.addressController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('location_on_map'), style: AppTextStyles.font14BlackRegular),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _isGeocoding ? null : () => _openPicker(context),
          child: Container(
            height: _hasLocation ? 64.h : 52.h,
            decoration: BoxDecoration(
              color: _hasLocation
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _hasLocation ? AppColors.primary : AppColors.borderGrey,
                width: _hasLocation ? 1.5 : 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                if (_isGeocoding)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                else
                  Icon(
                    _hasLocation
                        ? Icons.location_on
                        : Icons.location_on_outlined,
                    color: _hasLocation
                        ? AppColors.primary
                        : AppColors.greyText,
                    size: 22.w,
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _isGeocoding
                      ? Text(
                          tr('determining_address'),
                          style: AppTextStyles.font14GreyRegular,
                        )
                      : _hasLocation
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('selected_location'),
                              style: AppTextStyles.font12GreyRegular,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              widget.addressController.text.isNotEmpty
                                  ? widget.addressController.text
                                  : '${widget.latController.text} , ${widget.lngController.text}',
                              style: AppTextStyles.font14BlackRegular.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      : Text(
                          tr('choose_location_from_map'),
                          style: AppTextStyles.font14GreyRegular,
                        ),
                ),
                if (_hasLocation && !_isGeocoding)
                  GestureDetector(
                    onTap: _clearLocation,
                    child: Icon(
                      Icons.close,
                      color: AppColors.greyText,
                      size: 18.w,
                    ),
                  )
                else if (!_isGeocoding)
                  Icon(
                    Icons.map_outlined,
                    color: AppColors.greyText,
                    size: 20.w,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
