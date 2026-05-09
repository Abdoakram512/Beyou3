import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/config/assets/app_assets.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final double? width;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String bkgAsset = _getBackgroundAsset();

    return InkWell(
      onTap: onTap ??
          () {
            if (category.hasChildren) {
              context.push('/subcategories', extra: category);
            } else {
              final encodedName = Uri.encodeComponent(category.name);
              context.push(
                '/category-ads?id=${category.id}&name=$encodedName',
                extra: category,
              );
            }
          },
      child: Container(
        width: width ?? double.infinity,
        height: 110.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          image: DecorationImage(
            image: AssetImage(bkgAsset),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(12.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Text(
                      category.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: Align(
                    alignment: Alignment
                        .bottomRight, // بدل bottomCenter خليها bottomRight
                    child: FractionalTranslation(
                      translation: const Offset(
                        -0.0,
                        0,
                      ), // حركها 10% ناحية اليمين
                      child: FractionallySizedBox(
                        widthFactor: 1.2,
                        heightFactor: 1.1,
                        child:
                            category.image != null && category.image!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: category.image!,
                                memCacheWidth:
                                    (250 *
                                            MediaQuery.of(
                                              context,
                                            ).devicePixelRatio)
                                        .toInt(),
                                memCacheHeight:
                                    (250 *
                                            MediaQuery.of(
                                              context,
                                            ).devicePixelRatio)
                                        .toInt(),
                                placeholder: (context, url) =>
                                    const AppLoadingIndicator(size: 80),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.category, size: 40),
                                fit: BoxFit.contain,
                              )
                            : const Icon(
                                Icons.category,
                                size: 60,
                                color: AppColors.grey,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getBackgroundAsset() {
    final backgrounds = AppAssets.categoryBackgrounds;
    return backgrounds[category.id % backgrounds.length];
  }
}
