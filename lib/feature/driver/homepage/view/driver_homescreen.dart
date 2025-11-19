import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/driver/homepage/controller/driver_home_controller.dart';
import 'package:ride_sharing/feature/driver/trip_flow/view/driver_trip_flow.dart';
import 'package:ride_sharing/utils/driver/driver_custom_drawer.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import '../../../../app/utils/app_colors.dart';
import '../utils/driver_google_map_widget.dart';
import 'package:ride_sharing/utils/passenger/passenger_custom_drawer.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  late AnimationController _animationController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rippleAnimation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomToggleSwitch(
          isOnline: _isOnline,
          onChanged: (value) {
            setState(() {
              _isOnline = value;
              if (_isOnline) {
                _animationController.forward();
              } else {
                _animationController.stop();
              }
            });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LogoWidget(
              width: 40.0,
              height: 40.0,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
      drawer: const DriverCustomDrawer(),
      body: GetBuilder<DriverHomeScreenController>(
        init: DriverHomeScreenController(),
        builder: (controller) {
          return Stack(
            children: [
              // 🗺️ Map
              const DriverGoogleMapWidget(),

              // 🌀 Loading state
              if (controller.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),

              if (controller.currentPosition != null &&
                  !controller.isLoading &&
                  _isOnline)
                Positioned.fill(
                  child: Center(
                    child: PulsingLocationIndicator(
                      animation: _rippleAnimation,
                      centerIcon: Icons.location_on,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.7),
                        AppColors.primaryColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),

              //  Glass dialog (only when offline)
              // Glass dialog (only when offline)
              if (!_isOnline)
                Positioned(
                  bottom: 50.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: GlassCard(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'You are offline',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.tesxtColor,
                                        ),
                                      ),
                                    ),
                                   // SizedBox(height: 8.h),
                                    Text(
                                      'Go online to get trips and earn money.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.tesxtColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              SizedBox(
                                width: 80.w,
                                height: 60.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 8.h,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isOnline = true;
                                      _animationController.forward();
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const DriverTripFlow(),
                                    );

                                 //   Get.to(DriverTripFlow);
                                  },
                                  child: Text(
                                    'Go\nOnline',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              // if (_isOnline && !controller.isLoading)
                              //    DriverTripFlow(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


            ],
          );
        },
      ),
    );
  }
}

// =============== REUSABLE WIDGETS ===============

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 98.h,
    //  color: Colors.black.withOpacity(0.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.w,
        ),
        color: Colors.white.withOpacity(0.3),
      ),
      padding: padding,
      child: child,
    );
  }
}

class PulsingLocationIndicator extends StatelessWidget {
  final Animation<double> animation;
  final IconData centerIcon;
  final List<Color> colors;

  const PulsingLocationIndicator({
    super.key,
    required this.animation,
    required this.centerIcon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: animation.value.w,
              height: animation.value.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[2],
              ),
            ),
            // Middle ring
            Container(
              width: (animation.value * 0.7).w,
              height: (animation.value * 0.7).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[1],
              ),
            ),
            // Center pin
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[0],
              ),
              child: Icon(
                centerIcon,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ],
        );
      },
    );
  }
}

class StatusAlertBanner extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggle;

  const StatusAlertBanner({
    super.key,
    required this.isOnline,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
      Expanded(
      child: Text(
      isOnline
      ? 'you are online'
            : 'You are offline',
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.black87,
      ),
    ),
    ),
    SizedBox(width: 16.w),
    ElevatedButton(
    onPressed: onToggle,
    style: ElevatedButton.styleFrom(
    backgroundColor: isOnline
    ? AppColors.violetShade
        : AppColors.primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.r),
    ),
    ),
    child: Text(
    isOnline ? 'Go Offline' : 'Go Online',
    style: TextStyle(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),
    ],
    ),
    );
  }
}

class CustomToggleSwitch extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isOnline),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70.w,
        height: 36.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isOnline ? AppColors.primaryColor : Colors.grey[400],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isOnline ? 34.w : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isOnline ? Icons.location_on : Icons.location_on,
                  color: isOnline ? AppColors.primaryColor : AppColors.violetShade,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}