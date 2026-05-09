import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      offsetToArmed: 80.h,
      triggerMode: IndicatorTriggerMode.onEdge,
      builder: (context, child, controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final double progress = controller.value.clamp(0.0, 1.0);
            final double eased = Curves.easeOutCubic.transform(progress);
            final bool isArmed = controller.isArmed;
            final bool isLoading = controller.state == IndicatorState.loading;
            final bool isVisible = !controller.isIdle;

            final double pushDown =
                88.h * Curves.easeOutQuart.transform(progress);
            final double indicatorTop = 16.h + (20.h * eased).clamp(0.0, 24.h);

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Transform.translate(offset: Offset(0, pushDown), child: child),
                if (isVisible)
                  Positioned(
                    top: indicatorTop,
                    child: _RefreshPill(
                      progress: progress,
                      eased: eased,
                      isArmed: isArmed,
                      isLoading: isLoading,
                    ),
                  ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}

class _RefreshPill extends StatelessWidget {
  final double progress;
  final double eased;
  final bool isArmed;
  final bool isLoading;

  const _RefreshPill({
    required this.progress,
    required this.eased,
    required this.isArmed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = isArmed || isLoading;

    // Pill width: compact circle → full pill
    final double minW = 42.0.w;
    final double maxW = 168.0.w;
    final double pillW = isExpanded
        ? maxW
        : (minW + (maxW - minW) * eased * 0.4);

    final double pillH = 38.h;
    final double radius = pillH / 2;

    // Color shifts: loading gets a success-tint feel
    final Color iconColor = isLoading ? AppColors.success : AppColors.primary;
    final Color textColor = isLoading ? AppColors.success : AppColors.primary;

    return Opacity(
      opacity: eased.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: (0.72 + 0.28 * eased).clamp(0.72, 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          width: pillW,
          height: pillH,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.06),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon area — fixed size, content swaps
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: isLoading
                        ? _Spinner(color: iconColor)
                        : _ArrowIcon(flipped: isArmed, color: iconColor),
                  ),

                  // Sliding label
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: isExpanded
                        ? Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Text(
                              isLoading
                                  ? tr('refresh_loading')
                                  : tr('refresh_release'),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                letterSpacing: 0.1,
                              ),
                              maxLines: 1,
                              softWrap: false,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pure CSS spinner — no Lottie needed, lighter & instant
class _Spinner extends StatefulWidget {
  final Color color;
  const _Spinner({required this.color});

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: CustomPaint(painter: _ArcPainter(color: widget.color)),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  const _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    // Track
    canvas.drawCircle(center, radius, paint);

    // Arc
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90°
      4.0, // ~230°
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.color != color;
}

/// Arrow icon — flips instantly when armed (snap feedback)
class _ArrowIcon extends StatelessWidget {
  final bool flipped;
  final Color color;

  const _ArrowIcon({required this.flipped, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: flipped ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: color),
    );
  }
}
