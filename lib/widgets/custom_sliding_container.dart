import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A customizable indicator widget for onboarding screens
///
/// This widget displays a set of indicator dots to show the current page
/// in an onboarding flow. The active indicator is highlighted while others
/// are displayed in a muted color.
class OnboardingIndicator extends StatelessWidget {
  /// Total number of pages in the onboarding flow
  final int totalPages;

  /// Current active page index (0-based)
  final int currentPage;

  /// Width of the active indicator
  final double activeWidth;

  /// Width of inactive indicators
  final double inactiveWidth;

  /// Height of all indicators
  final double height;

  /// Border radius of the indicators
  final double borderRadius;

  /// Color of the active indicator
  final Color activeColor;

  /// Color of inactive indicators
  final Color inactiveColor;

  /// Spacing between indicators
  final double spacing;

  const OnboardingIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    this.activeWidth = 21,
    this.inactiveWidth = 13,
    this.height = 5,
    this.borderRadius = 100,
    required this.activeColor,
    required this.inactiveColor,
    this.spacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) {
          final isActive = index == currentPage;
          return Padding(
            padding: EdgeInsets.only(
              right: index < totalPages - 1 ? spacing : 0,
            ),
            child: Container(
              width: isActive ? activeWidth.w : inactiveWidth.w,
              height: height.h,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(borderRadius.r),
              ),
            ),
          );
        },
      ),
    );
  }
}