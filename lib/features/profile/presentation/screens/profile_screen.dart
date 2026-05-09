import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/copyright_widget.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_header.dart';

import '../widgets/profile_menu_items_list.dart';
import '../widgets/profile_logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: tr('profile'),
        showBackButton: context.canPop(),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (state is ProfileLoading || state is ProfileInitial)
                  const AppLoadingIndicator()
                else if (state is ProfileLoaded)
                  ProfileHeader(user: state.user)
                else if (state is ProfileGuest)
                  const ProfileHeader(user: null)
                else if (state is ProfileError)
                  AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<ProfileCubit>().getProfile(),
                  ),

                SizedBox(height: 10.h),
                ProfileMenuItemsList(state: state),
                SizedBox(height: 32.h),
                ProfileLogoutButton(isGuest: state is ProfileGuest),
                SizedBox(height: 80.h),
                const CopyrightWidget(),
                SizedBox(height: 25.h), // Bottom nav space
              ],
            ),
          );
        },
      ),
    );
  }
}
