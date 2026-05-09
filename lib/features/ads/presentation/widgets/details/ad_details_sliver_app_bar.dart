import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common/glass_icon_button.dart';
import '../../../domain/entities/ad_details_entity.dart';
import 'ad_details_image_slider.dart';

class AdDetailsSliverAppBar extends StatefulWidget {
  final AdDetailsEntity ad;
  final bool isMyAd;

  const AdDetailsSliverAppBar({
    super.key,
    required this.ad,
    this.isMyAd = false,
  });

  @override
  State<AdDetailsSliverAppBar> createState() => _AdDetailsSliverAppBarState();
}

class _AdDetailsSliverAppBarState extends State<AdDetailsSliverAppBar> {
  final CarouselSliderController _imageController = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final totalImages = widget.ad.images.length;

    return SliverAppBar(
      expandedHeight: 0.35.sh,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: 18.w, top: 8.h, bottom: 8.h),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
        ),
      ),
      actions: [
        if (widget.isMyAd)
          Padding(
            padding: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
            child: GlassIconButton(
              icon: Icons.edit_outlined,
              onTap: () => context.push('/edit-ad', extra: widget.ad),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ── Image Slider ──
            AdDetailsImageSlider(
              images: widget.ad.images,
              adId: widget.ad.id.toString(),
              controller: _imageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
            ),

            // ── Left Arrow ──
            if (totalImages > 1 && _currentPage > 0)
              Positioned(
                left: 10.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => _imageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),

            // ── Right Arrow ──
            if (totalImages > 1 && _currentPage < totalImages - 1)
              Positioned(
                right: 10.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GlassIconButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () => _imageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),

            // ── Dots Indicator ──
            if (totalImages > 1)
              Positioned(
                bottom: 88.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalImages, (i) {
                    final isActive = _currentPage == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: isActive ? 16.w : 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    );
                  }),
                ),
              ),

            // ── bottom fade ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.6),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
