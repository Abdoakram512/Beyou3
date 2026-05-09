import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'my_ad_card.dart';

class MyAdsListView extends StatelessWidget {
  final List ads;

  const MyAdsListView({
    super.key,
    required this.ads,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 300,
      addRepaintBoundaries: false,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: MyAdCard(
              ad: ads[index],
              onTap: () =>
                  context.push('/ad-details/${ads[index].id}?isMyAd=true'),
              onEdit: () => context.push(
                '/ad-details/${ads[index].id}?isMyAd=true&edit=true',
              ),
            ),
          ),
        );
      },
    );
  }
}
