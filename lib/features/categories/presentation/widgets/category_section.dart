import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../helpers/category_layout_helper.dart';
import 'category_card.dart';

class CategorySection extends StatelessWidget {
  final CategoryEntity rootCategory;

  const CategorySection({super.key, required this.rootCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: decorative accent + title
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Accent bar
                    Container(
                      width: 4.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        rootCategory.name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.authSectionTitleColor,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              // Right: "Show All" button
              InkWell(
                onTap: () {
                  final encodedName = Uri.encodeComponent(rootCategory.name);
                  if (rootCategory.hasChildren) {
                    context.push('/subcategories', extra: rootCategory);
                  } else {
                    context.push(
                      '/category-ads?id=${rootCategory.id}&name=$encodedName',
                      extra: rootCategory,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Text(
                    tr('see_all'),
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double availableWidth = constraints.maxWidth;
              double spacing = 12.w;

              return Wrap(
                spacing: spacing,
                runSpacing: 12.h,
                children: rootCategory.children.asMap().entries.map((entry) {
                  int index = entry.key;
                  CategoryEntity child = entry.value;
                  double width = CategoryLayoutHelper.calculateWidth(
                    index: index,
                    totalWidth: availableWidth,
                    spacing: spacing,
                    totalCount: rootCategory.children.length,
                  );
                  return CategoryCard(
                    category: child,
                    width: width,
                    onTap: () {
                      context.push('/subcategories', extra: child);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
