import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/feedback/app_empty_state.dart';

class CategoryAdsEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onReset;

  const CategoryAdsEmptyState({
    super.key,
    required this.isFiltered,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: isFiltered ? tr('no_match_found') : tr('no_ads_yet'),
      subtitle: isFiltered ? tr('try_changing_filters') : tr('start_adding_ads_now'),
      lottieAsset: 'assets/animations/Empty.json',
      icon: Icons.search_off_rounded,
      actionLabel: isFiltered ? tr('reset') : tr('add_ad'),
      onActionPressed: isFiltered ? onReset : () => context.push('/create-ad'),
    );
  }
}
