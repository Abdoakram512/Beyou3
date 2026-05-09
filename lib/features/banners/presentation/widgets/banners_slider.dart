import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';

class BannersSlider extends StatefulWidget {
  final List<String> banners;

  const BannersSlider({super.key, required this.banners});

  @override
  State<BannersSlider> createState() => _BannersSliderState();
}

class _BannersSliderState extends State<BannersSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider(
          items: widget.banners.map((url) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  memCacheWidth:
                      (0.9.sw * MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                  placeholder: (context, url) => Container(
                    color: AppColors.handleGrey,
                    child: const AppLoadingIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.handleGrey,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 0.28.sh,
            autoPlay: true,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppColors.primary
                    : AppColors.handleGrey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
