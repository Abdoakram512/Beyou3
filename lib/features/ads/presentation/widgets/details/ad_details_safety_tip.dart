import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdDetailsSafetyTip extends StatelessWidget {
  const AdDetailsSafetyTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, size: 18.r, color: Colors.amber[700]),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              tr('safety_tip'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.amber[800],
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
