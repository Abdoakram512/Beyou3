import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/widgets/feedback/app_loading_indicator.dart';
import 'package:beyou3/features/ads/domain/entities/ad_details_entity.dart';
import 'ad_details_fullscreen_slider.dart';

class AdDetailsImageSlider extends StatelessWidget {
  final List<AdImageEntity> images;
  final String adId;
  final CarouselSliderController? controller;
  final void Function(int index)? onPageChanged;

  const AdDetailsImageSlider({
    super.key,
    required this.images,
    required this.adId,
    this.controller,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: controller,
      options: CarouselOptions(
        height: 0.4.sh,
        viewportFraction: 1.0,
        enableInfiniteScroll: images.length > 1,
        onPageChanged: (index, reason) {
          if (onPageChanged != null) onPageChanged!(index);
        },
      ),
      items: images.asMap().entries.map((entry) {
        final index = entry.key;
        final img = entry.value;
        return Builder(
          builder: (BuildContext context) {
            Widget imageWidget = CachedNetworkImage(
              imageUrl: img.url,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: AppColors.lightGrey,
                child: const AppLoadingIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.lightGrey,
                child: const Icon(Icons.error, color: AppColors.error),
              ),
            );

            Widget finalImage;
            if (index == 0) {
              finalImage = Hero(tag: 'ad_$adId', child: imageWidget);
            } else {
              finalImage = imageWidget;
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdDetailsFullscreenSlider(
                      images: images,
                      initialIndex: index,
                      adId: adId,
                    ),
                  ),
                );
              },
              child: finalImage,
            );
          },
        );
      }).toList(),
    );
  }
}
