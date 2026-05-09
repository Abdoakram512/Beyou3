import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// =============================================================
// HERO SECTION
// =============================================================

class SuccessHeroSection extends StatefulWidget {
  const SuccessHeroSection({super.key});

  @override
  State<SuccessHeroSection> createState() => _SuccessHeroSectionState();
}

class _SuccessHeroSectionState extends State<SuccessHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _pulseController;
  late Animation<double> _checkProgress;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  static const _primaryColor = Color(
    0xFFFB8C00,
  ); // More vibrant, premium orange
  static const _accentColor = Color(0xFFFFB74D); // Lighter accent for gradients

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkProgress = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseScale = Tween<double>(
      begin: 1.0,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.35,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _checkController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedBottomClipper(),
      child: Container(
        width: double.infinity,
        height: 0.35.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_accentColor, _primaryColor],
          ),
        ),
        child: Stack(
          children: [
            // decorative circle top-right
            Positioned(
              top: -30.h,
              right: -40.w,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            // decorative circle bottom-left
            Positioned(
              bottom: 50.h,
              left: -20.w,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
              ),
            ),

            // main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  SizedBox(height: 16.h),

                  // pulse + checkmark
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // outer pulse ring
                          Transform.scale(
                            scale: _pulseScale.value,
                            child: Opacity(
                              opacity: _pulseOpacity.value,
                              child: Container(
                                width: 110.w,
                                height: 110.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // semi-transparent ring
                          Container(
                            width: 110.w,
                            height: 110.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          // white inner circle with checkmark
                          Container(
                            width: 84.w,
                            height: 84.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(child: child),
                          ),
                        ],
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _checkProgress,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(40.w, 40.w),
                          painter: _CheckmarkPainter(
                            progress: _checkProgress.value,
                            color: _primaryColor,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    tr('ad_published_success'),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    tr('ad_under_review_note'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// CURVED BOTTOM CLIPPER
// =============================================================

class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40.h);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30.h,
      size.width,
      size.height - 40.h,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

// =============================================================
// CHECKMARK CUSTOM PAINTER
// =============================================================

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5.w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final p1 = Offset(size.width * 0.18, size.height * 0.52);
    final p2 = Offset(size.width * 0.42, size.height * 0.72);
    final p3 = Offset(size.width * 0.82, size.height * 0.28);

    final path = Path();
    if (progress <= 0.5) {
      final t = progress / 0.5;
      final mid = Offset.lerp(p1, p2, t)!;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(mid.dx, mid.dy);
    } else {
      final t = (progress - 0.5) / 0.5;
      final mid2 = Offset.lerp(p2, p3, t)!;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(mid2.dx, mid2.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) => old.progress != progress;
}
