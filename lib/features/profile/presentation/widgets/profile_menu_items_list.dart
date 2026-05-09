import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/dialogs/login_requirement_dialog.dart';
import '../cubit/profile_state.dart';
import 'profile_menu_item.dart';

class ProfileMenuItemsList extends StatelessWidget {
  final ProfileState state;

  const ProfileMenuItemsList({super.key, required this.state});

  void _handleMenuTap(BuildContext context, String path) {
    if (state is ProfileLoaded) {
      context.push(path);
    } else if (state is ProfileGuest) {
      LoginRequirementDialog.show(context, redirectPath: path);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("please_wait".tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          svgIcon: AppIcons.person,
          title: "personal_data".tr(),
          onTap: () => _handleMenuTap(context, '/personal-data'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.ads,
          title: "my_ads".tr(),
          onTap: () => _handleMenuTap(context, '/my-ads'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.language,
          title: "arabic_language".tr(),
          trailing: Switch.adaptive(
            value: context.locale.languageCode == 'ar',
            activeTrackColor: AppColors.primary,
            onChanged: (val) async {
              final newLocale = val ? const Locale('ar') : const Locale('en');
              await context.setLocale(newLocale);
              await SharedPrefHelper.saveData(
                key: 'language',
                value: newLocale.languageCode,
              );
            },
          ),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.exclamationmark,
          title: "about_us".tr(),
          onTap: () => context.push('/about-us'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.help,
          title: "how_we_work".tr(),
          onTap: () => context.push('/how-we-work'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.phone,
          title: "contact_us".tr(),
          onTap: () => context.push('/contact-us'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.help,
          title: "faqs".tr(),
          onTap: () => context.push('/faqs'),
        ),
        ProfileMenuItem(
          icon: Icons.notifications,
          title: "notifications".tr(),
          onTap: () => _handleMenuTap(context, '/notifications'),
        ),
        ProfileMenuItem(
          svgIcon: AppIcons.setting,
          title: "app_settings".tr(),
          onTap: () => context.push('/app-settings'),
        ),
      ],
    );
  }
}
