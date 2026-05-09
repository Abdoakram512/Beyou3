import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../cubit/create_ad_cubit.dart';
import '../cubit/create_ad_state.dart';
import '../cubit/ad_category_selection_cubit.dart';
import '../../../main/presentation/screens/main_screen.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../widgets/create_ad_step1_basic_data.dart';
import '../widgets/create_ad_step2_details.dart';
import '../widgets/create_ad_step3_images.dart';
import '../widgets/create_ad_step_progress_bar.dart';
import '../widgets/create_ad_bottom_bar.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _pageController = PageController();

  final _step1Key = GlobalKey<CreateAdStep1BasicDataState>();
  final _step2Key = GlobalKey<CreateAdStep2DetailsState>();
  final _step3Key = GlobalKey<CreateAdStep3ImagesState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext(CreateAdCubit cubit, CreateAdState state) {
    if (state.status == CreateAdStatus.loading) return;

    final step = state.currentStep;
    bool isValid = false;

    if (step == 0) {
      isValid = _step1Key.currentState?.validateAndSave() ?? false;
    } else if (step == 1) {
      isValid = _step2Key.currentState?.validateAndSave() ?? false;
    } else if (step == 2) {
      isValid = _step3Key.currentState?.validateAndSave() ?? false;
      if (isValid) {
        cubit.createAd();
      }
    }

    if (isValid && step < 2) {
      _pageController.animateToPage(
        step + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePrevious(CreateAdCubit cubit, int currentStep) {
    if (currentStep > 0) {
      _pageController.animateToPage(
        currentStep - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      cubit.previousStep();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CategoriesCubit>()..getCategories()),
        BlocProvider(create: (_) => getIt<AdCategorySelectionCubit>()),
        BlocProvider(create: (_) => getIt<CreateAdCubit>()),
      ],
      child: BlocConsumer<CreateAdCubit, CreateAdState>(
        listener: (context, state) {
          if (state.status == CreateAdStatus.success) {
            context.read<CreateAdCubit>().reset();
            _pageController.jumpToPage(0);
            context.go('/create-ad-success');
          } else if (state.status == CreateAdStatus.failure &&
              state.errorMessage != null) {
            // ✅ Fix 3.7: AppSnackBar for consistent error feedback
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateAdCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(
              title: tr('add_ad_title'),
              onBack: () {
                if (state.currentStep > 0) {
                  _handlePrevious(cubit, state.currentStep);
                } else if (context.canPop()) {
                  context.pop();
                } else {
                  // Accessed from bottom tab — switch to Home tab
                  MainScreen.switchToTab(0);
                }
              },
            ),
            body: Column(
              children: [
                SizedBox(height: 16.h),
                CreateAdStepProgressBar(
                  currentStep: state.currentStep,
                  totalSteps: 3,
                ),
                Expanded(child: _buildPageView(state)),
                CreateAdBottomBar(
                  currentStep: state.currentStep,
                  isLoading: state.status == CreateAdStatus.loading,
                  onNext: () => _handleNext(cubit, state),
                  onPrevious: () => _handlePrevious(cubit, state.currentStep),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageView(CreateAdState state) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CreateAdStep1BasicData(key: _step1Key),
        CreateAdStep2Details(key: _step2Key),
        CreateAdStep3Images(key: _step3Key),
      ],
    );
  }
}
