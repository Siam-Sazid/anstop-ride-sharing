import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/passenger/homepage/view/home_page.dart';
import 'package:ride_sharing/utils/user_info_section.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_horizontal_line.dart';
import 'package:ride_sharing/widgets/custom_vertical_line.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class PassengerPaymentScreen extends StatefulWidget {
  const PassengerPaymentScreen({super.key});

  @override
  State<PassengerPaymentScreen> createState() => _PassengerPaymentScreenState();
}

class _PassengerPaymentScreenState extends State<PassengerPaymentScreen> {
  @override
  Widget build(BuildContext context) {
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
              imageUrl: 'https://picsum.photos/250?image=9',
              name: 'John Doe',
              rating: 3.54,
              trips: 3,
              profession: 'Professional',
              price: '\$24',
              distance: '28 km',
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
                  Text(AppString.yourTripLabel,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8.sp,),
                  Row(children: [
                    Container(
                      child: Image.asset(AppImage.greetings),
                    ),
                    SizedBox(width: 5.sp,),
                    Text(AppString.pickupLocationExample),

                  ],),
                  CustomVerticalLine(height: 20.h, color: Colors.black),
                  Row(children: [
                    Container(
                      child: Icon(Icons.location_on,color: AppColors.green300,),
                    ),
                    SizedBox(width: 5.sp,),
                    Text(AppString.dropoffLocationExample),

                  ],),
                  SizedBox(height: 8.sp,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.distanceLabel,style: TextStyle(
                          fontSize: 18.sp,color: Colors.black
                      ),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(AppString.distanceExample,),

                    ],),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Travel time ',style: TextStyle(
                          fontSize: 18.sp,color: Colors.black
                      ),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(AppString.durationExample),

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
                  Text(AppString.payViaWalletLabel,style: TextStyle(fontSize: 20.sp),),
                  Spacer(),
                  Text(AppString.fareExample,style: TextStyle(fontSize: 20  .sp),),
                ],
              ),
            ),
          ),
       


        ]
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(onPressed: (){
          _showRatingDialog(context);
        },
       title: Text(AppString.confirmPaymentTitle,style: TextStyle(color: AppColors.white),),
      ),
      ),
    );
  }}

void _showRatingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero, // Remove default padding
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom title with close button
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8), // Align with icon center
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
                  // Positioned(
                  //   right: 0,
                  //   top: 0,
                  //   child: IconButton(
                  //     icon: Icon(Icons.close),
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //     padding: EdgeInsets.zero,
                  //     constraints: BoxConstraints(),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Rest of your content
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
                      hintText: AppString.writeCommentsHint,
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
              // Thank You Message
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
              // Close button
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: CustomButton(
                  onPressed: () {
                   Get.to(HomePage());
                  },
                  title: Text(AppString.backToHomeButton, style: TextStyle(fontSize: 20, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
