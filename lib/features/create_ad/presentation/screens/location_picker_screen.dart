import 'dart:async';
import 'package:beyou3/core/widgets/common/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';

class LocationPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const LocationPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357); // Cairo

  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);
      _updateMarker(_selectedLocation!);
    }
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _selectedLocation = newPosition;
            });
          },
        ),
      };
    });
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack(tr('enable_location_service'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack(tr('location_permission_denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack(tr('location_permission_denied_forever'));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);
      _updateMarker(currentLatLng);

      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 15),
        ),
      );
    } catch (e) {
      _showSnack(tr('unable_to_determine_location'));
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // ✅ Fix 3.7: Replaced with AppSnackBar.showError
  void _showSnack(String msg) => AppSnackBar.showError(context, msg);

  void _confirmSelection() {
    if (_selectedLocation == null) {
      _showSnack(tr('please_select_location_first'));
      return;
    }
    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr('choose_location'),
        actions: [
          if (_selectedLocation != null)
            TextButton(
              onPressed: _confirmSelection,
              child: Text(
                tr('confirm'),
                style: AppTextStyles.font14BlackRegular.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? _defaultLocation,
              zoom: _selectedLocation != null ? 15 : 10,
            ),
            onMapCreated: (controller) => _mapController.complete(controller),
            markers: _markers,
            onTap: (position) => _updateMarker(position),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),

          // Info card at top
          Positioned(
            top: 12.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      tr('map_picker_hint'),
                      style: AppTextStyles.font12GreyRegular,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Coordinates card at bottom
          if (_selectedLocation != null)
            Positioned(
              bottom: 100.h,
              left: 16.w,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr('selected_location'),
                      style: AppTextStyles.font14BlackRegular.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _CoordRow(
                      label: tr('latitude_label'),
                      value: _selectedLocation!.latitude.toStringAsFixed(6),
                    ),
                    SizedBox(height: 4.h),
                    _CoordRow(
                      label: tr('longitude_label'),
                      value: _selectedLocation!.longitude.toStringAsFixed(6),
                    ),
                  ],
                ),
              ),
            ),

          // Confirm button
          Positioned(
            bottom: 24.h,
            left: 24.w,
            right: 24.w,
            child: ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 2,
              ),
              child: Text(
                tr('confirm_location'),
                style: AppTextStyles.font16BlackMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          // Current location FAB
          Positioned(
            bottom: 100.h,
            right: 16.w,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.white,
              elevation: 4,
              onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
              child: _isLoadingLocation
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordRow extends StatelessWidget {
  final String label;
  final String value;

  const _CoordRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.font12GreyRegular),
        Text(value, style: AppTextStyles.font14BlackRegular),
      ],
    );
  }
}
