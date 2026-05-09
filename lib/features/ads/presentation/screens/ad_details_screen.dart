import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_bottom_actions.dart';
import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_description.dart';
import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_features.dart';
import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_info_section.dart';
import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_owner_card.dart';
import 'package:beyou3/features/ads/presentation/widgets/details/ad_details_sliver_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../../domain/entities/ad_details_entity.dart';
import '../cubit/ad_details_cubit.dart';
import '../cubit/ad_details_state.dart';
import '../widgets/details/ad_details_divider.dart';
import '../widgets/details/ad_details_safety_tip.dart';
import '../widgets/details/ad_details_section_label.dart';

class AdDetailsScreen extends StatefulWidget {
  final String id;
  final bool isMyAd;
  final bool isEditing;

  const AdDetailsScreen({
    super.key,
    required this.id,
    this.isMyAd = false,
    this.isEditing = false,
  });

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<AdDetailsCubit>();
        if (widget.isMyAd) {
          cubit.getMyAdDetails(widget.id);
        } else {
          cubit.getAdDetails(widget.id);
        }
        return cubit;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: BlocListener<AdDetailsCubit, AdDetailsState>(
            listener: (context, state) {
              if (state is AdDetailsLoaded && widget.isEditing) {
                context.pushReplacement('/edit-ad', extra: state.adDetails);
              }
            },
            child: BlocBuilder<AdDetailsCubit, AdDetailsState>(
              builder: (context, state) {
                if (state is AdDetailsLoading || state is AdDetailsInitial) {
                  return const AppLoadingIndicator();
                } else if (state is AdDetailsError) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => widget.isMyAd
                        ? context.read<AdDetailsCubit>().getMyAdDetails(
                            widget.id,
                          )
                        : context.read<AdDetailsCubit>().getAdDetails(
                            widget.id,
                          ),
                  );
                } else if (state is AdDetailsLoaded) {
                  if (widget.isEditing) {
                    return const AppLoadingIndicator();
                  }
                  final ad = state.adDetails;
                  return Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          AdDetailsSliverAppBar(ad: ad, isMyAd: widget.isMyAd),
                          SliverToBoxAdapter(child: _buildContent(context, ad)),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AdDetailsBottomActions(ad: ad),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdDetailsEntity ad) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // ── info (title, price, badges, meta) ──
                AdDetailsInfoSection(ad: ad),

                const AdDetailsDivider(),

                if (_hasFeatures(ad)) ...[
                  AdDetailsSectionLabel(label: tr('details')),
                  SizedBox(height: 10.h),
                  AdDetailsFeatures(ad: ad),
                  const AdDetailsDivider(),
                ],

                // ── description ──
                AdDetailsDescription(description: ad.description),

                const AdDetailsDivider(),

                // ── owner ──
                if (ad.user != null) ...[
                  AdDetailsSectionLabel(label: tr('seller')),
                  SizedBox(height: 10.h),
                  AdDetailsOwnerCard(user: ad.user!),
                  const AdDetailsDivider(),
                ],

                // ── safety tip ──
                const AdDetailsSafetyTip(),

                // space for bottom bar
                SizedBox(height: 110.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasFeatures(AdDetailsEntity ad) {
    return ad.category != null ||
        (ad.brand != null && ad.brand!.isNotEmpty) ||
        (ad.purpose != null && ad.purpose!.isNotEmpty) ||
        (ad.status != null && ad.status!.isNotEmpty) ||
        (ad.area != null && ad.area!.isNotEmpty);
  }
}
