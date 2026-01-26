import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/passenger/homepage/view/home_page.dart';
import 'package:ride_sharing/services/stripe/stripe_config.dart';
import 'package:ride_sharing/services/stripe/stripe_helper.dart';
import 'package:ride_sharing/utils/user_info_section.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_horizontal_line.dart';
import 'package:ride_sharing/widgets/custom_vertical_line.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class PassengerPaymentScreen extends StatefulWidget {
  final String driverName;
  final String? driverProfilePicture;
  final double driverRating;
  final int driverTotalReviews;
  final String bidAmount;
  final String tripDistance;
  final String pickUpAddress;
  final String destinationAddress;
  final String paymentMethod; // WALLET, CASH, CARD from socket

  const PassengerPaymentScreen({
    super.key,
    this.driverName = '',
    this.driverProfilePicture,
    this.driverRating = 0.0,
    this.driverTotalReviews = 0,
    this.bidAmount = '',
    this.tripDistance = '',
    this.pickUpAddress = '',
    this.destinationAddress = '',
    this.paymentMethod = '',
  });

  @override
  State<PassengerPaymentScreen> createState() => _PassengerPaymentScreenState();
}

class _PassengerPaymentScreenState extends State<PassengerPaymentScreen> {
  late StripePaymentHelper _stripeHelper;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _initStripe();
  }

  void _initStripe() {
    final stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

    _stripeHelper = StripePaymentHelper(
      config: StripeConfig(
        secretKey: stripeSecretKey,
        merchantDisplayName: 'Ride Sharing App',
      ),
      onPaymentSuccess: (result) {
        print('Payment successful: ${result.paymentData}');
      },
      onPaymentFailure: (result) {
        print('Payment failed: ${result.message}');
      },
      onLog: (message) {
        print('[Stripe] $message');
      },
    );
  }

  // Helper to format payment method: WALLET -> Wallet, CASH -> Cash, CARD -> Card
  String _formatPaymentMethod(String method) {
    if (method.isEmpty) return 'Wallet';
    return method[0].toUpperCase() + method.substring(1).toLowerCase();
  }

  // Check if payment method requires Stripe (WALLET or CARD)
  bool _requiresStripePayment() {
    final method = widget.paymentMethod.toUpperCase();
    return method == 'WALLET' || method == 'CARD';
  }

  // Process payment based on payment method
  Future<void> _handleConfirmPayment(BuildContext context) async {
    if (_requiresStripePayment()) {
      await _processStripePayment(context);
    } else {
      // For CASH, directly show rating dialog
      _showRatingDialog(context);
    }
  }

  // Process Stripe payment for WALLET or CARD
  Future<void> _processStripePayment(BuildContext context) async {
    if (_isProcessingPayment) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // Parse the bid amount
      final amount = double.tryParse(widget.bidAmount) ?? 0;

      if (amount <= 0) {
        Get.snackbar(
          'Error',
          'Invalid payment amount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Process Stripe payment
      final paymentResult = await _stripeHelper.processPayment(
        context: context,
        amount: amount,
        currency: 'USD',
        description: 'Ride Payment - ${widget.pickUpAddress} to ${widget.destinationAddress}',
        showSuccessDialog: false,
      );

      if (paymentResult.isSuccess) {
        Get.snackbar(
          'Success',
          'Payment completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Show rating dialog after successful payment
        if (context.mounted) {
          _showRatingDialog(context);
        }
      } else {
        Get.snackbar(
          'Payment Failed',
          paymentResult.message ?? 'Payment could not be processed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use dynamic data or fallback to static
    final displayName = widget.driverName.isNotEmpty ? widget.driverName : 'John Doe';
    final displayImageUrl = widget.driverProfilePicture ?? 'https://picsum.photos/250?image=9';
    final displayRating = widget.driverRating > 0 ? widget.driverRating : 3.54;
    final displayTrips = widget.driverTotalReviews > 0 ? widget.driverTotalReviews : 3;
    final displayPrice = widget.bidAmount.isNotEmpty ? '\$${widget.bidAmount}' : '\$24';
    final displayDistance = widget.tripDistance.isNotEmpty ? '${widget.tripDistance} km' : '28 km';
    final displayPickup = widget.pickUpAddress.isNotEmpty
        ? widget.pickUpAddress
        : AppLocalization.tr.pickupLocationExample;
    final displayDestination = widget.destinationAddress.isNotEmpty
        ? widget.destinationAddress
        : AppLocalization.tr.dropoffLocationExample;
    final displayPaymentMethod = 'Pay via ${_formatPaymentMethod(widget.paymentMethod)}';

    return Scaffold(
     // backgroundColor: AppColors.white,
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        leading: Container(
         margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
           shape:  BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Color(0xFFEEEEEE),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            height: 50,
            color: Colors.transparent,
          ),
          Container(
            color: AppColors.white,
            child: UserInfoSection(
              imageUrl: displayImageUrl,
              name: displayName,
              rating: displayRating,
              trips: displayTrips,
              profession: 'Professional',
              price: displayPrice,
              distance: displayDistance,
            ),
          ),
        SizedBox(height: 8.sp,),
        CustomHorizontalLine(
          thickness: 20.sp,
        ),
          Container(
            color: AppColors.white,
           // elevation: 0,
            child: Padding(
              padding:  EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalization.tr.yourTripLabel,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8.sp,),
                  Row(children: [
                    Container(
                      child: Image.asset(AppImage.greetings),
                    ),
                    SizedBox(width: 5.sp,),
                    Expanded(
                      child: Text(
                        displayPickup,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],),
                  CustomVerticalLine(height: 20.h, color: Colors.black),
                  Row(children: [
                    Container(
                      child: Icon(Icons.location_on,color: AppColors.green300,),
                    ),
                    SizedBox(width: 5.sp,),
                    Expanded(
                      child: Text(
                        displayDestination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],),
                  SizedBox(height: 8.sp,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.tr.distanceLabel,style: TextStyle(
                          fontSize: 18.sp,color: Colors.black
                      ),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(displayDistance,),

                    ],),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.tr.timeExample,
                        style: TextStyle(
                          fontSize: 18.sp,color: Colors.black
                      ),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(AppLocalization.tr.durationExample),

                    ],),

                  // SizedBox(height: 8.h,),

                ],
              ),
            ),
          ),
          CustomHorizontalLine(
            thickness: 20.sp,
          ),
          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(AppImage.wallet),
                  SizedBox(width: 2.sp,),
                  Text(displayPaymentMethod,style: TextStyle(fontSize: 20.sp),),
                  Spacer(),
                  Text(displayPrice,style: TextStyle(fontSize: 20.sp),),
                ],
              ),
            ),
          ),
       


        ]
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          onPressed: _isProcessingPayment
              ? null
              : () {
                  _handleConfirmPayment(context);
                },
          title: _isProcessingPayment
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  AppLocalization.tr.confirmPaymentTitle,
                  style: TextStyle(color: AppColors.white),
                ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Give your ratings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    RatingBar.builder(
                      initialRating: 4.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: AppLocalization.tr.writeCommentsHint,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        _showThankYouDialog(context);
                      },
                      title: Text('Submit', style: TextStyle(fontSize: 20, color: AppColors.white)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    AppImage.thankyou,
                    height: 100,
                    width: 100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Thank you for your valuable feedback and tip!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: CustomButton(
                    onPressed: () {
                      Get.offAll(() => HomePage());
                    },
                    title: Text(AppLocalization.tr.backToHomeButton, style: TextStyle(fontSize: 20, color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

