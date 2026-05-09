import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/ad_entity.dart';
import 'ad_card.dart';

class CategoryAdsGrid extends StatelessWidget {
  final List<AdEntity> ads;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const CategoryAdsGrid({
    super.key,
    required this.ads,
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            cacheExtent: 300,
            addRepaintBoundaries: false,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.58,
            ),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: AdCard(ad: ads[index]),
              );
            },
          ),
        ),
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const CircularProgressIndicator.adaptive(),
          ),
      ],
    );
  }
}
