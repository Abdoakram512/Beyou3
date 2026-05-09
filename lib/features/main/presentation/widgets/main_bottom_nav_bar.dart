import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_icons.dart';
import 'main_nav_item.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MainBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainNavItem(
                index: 0,
                iconPath: AppIcons.home,
                labelKey: 'home',
                isSelected: selectedIndex == 0,
                onTap: () => onItemSelected(0),
              ),
              MainNavItem(
                index: 1,
                iconPath: AppIcons.categories,
                labelKey: 'categories_tab',
                isSelected: selectedIndex == 1,
                onTap: () => onItemSelected(1),
              ),
              MainNavItem(
                index: 2,
                iconPath: AppIcons.plus,
                labelKey: 'add_ad',
                isSelected: selectedIndex == 2,
                onTap: () => onItemSelected(2),
              ),
              MainNavItem(
                index: 3,
                iconPath: AppIcons.ads,
                labelKey: 'my_ads',
                isSelected: selectedIndex == 3,
                onTap: () => onItemSelected(3),
              ),
              MainNavItem(
                index: 4,
                iconPath: AppIcons.profile,
                labelKey: 'profile',
                isSelected: selectedIndex == 4,
                onTap: () => onItemSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
