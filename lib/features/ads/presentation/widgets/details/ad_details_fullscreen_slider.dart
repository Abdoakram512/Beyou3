import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/widgets/feedback/app_loading_indicator.dart';
import 'package:beyou3/features/ads/domain/entities/ad_details_entity.dart';

class AdDetailsFullscreenSlider extends StatefulWidget {
  final List<AdImageEntity> images;
  final int initialIndex;
  final String adId;

  const AdDetailsFullscreenSlider({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.adId,
  });

  @override
  State<AdDetailsFullscreenSlider> createState() =>
      _AdDetailsFullscreenSliderState();
}

class _AdDetailsFullscreenSliderState extends State<AdDetailsFullscreenSlider> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fullscreen PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              Widget imageWidget = CachedNetworkImage(
                imageUrl: widget.images[index].url,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => const AppLoadingIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: AppColors.error, size: 50),
              );

              if (index == 0) {
                imageWidget = Hero(
                  tag: 'ad_${widget.adId}',
                  child: imageWidget,
                );
              }

              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(child: imageWidget),
              );
            },
          ),

          // Top Bar (Close and Index)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),

                // Index Indicator
                if (widget.images.length > 1)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Empty space to balance the header if index is not shown
                if (widget.images.length <= 1) SizedBox(width: 40.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
