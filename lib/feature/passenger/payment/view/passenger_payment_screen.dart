import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    //  backgroundColor: AppColors.white,
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
           SizedBox(height: 10.sp,),
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
            width: double.infinity,
            child: Padding(
              padding:  EdgeInsets.all(16.sp),
              child: Text('Your trip',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
            ),
          ),
          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:  16.sp),
              child: Row(children: [
                Container(
                  child: Image.asset('assets/images/greetings.png'),
                ),
                SizedBox(width: 5.sp,),
                Text('Block b / Banasree, Dhaka'),

              ],),
            ),
          ),
         // SizedBox(height: 8.sp,),



             Container(
              color: AppColors.white, // Outer container with white background
              width: double.infinity, // Full width
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 1.0, // This is the width of the vertical line
                  color: Colors.black, // Black line color
                  height: 30.h, // Height of the vertical line
                ),
              ),
            ),



          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:  16.sp),
              child: Row(children: [
                Container(
                  child: Icon(Icons.location_on,color: AppColors.primaryColor,),
                ),
                SizedBox(width: 5.sp,),
                Text('Green Road Dhaka'),

              ],
              ),
            ),
          ),
          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Distance',style: TextStyle(fontSize: 15.sp),),
                  Spacer(),
                  Text('48 km',style: TextStyle(fontSize: 20.sp),)
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Travel Time',style: TextStyle(fontSize: 15.sp),),
                  Spacer(),
                  Text('50 min',style: TextStyle(fontSize: 20.sp),)
                ],
              ),
            ),
          ),
          SizedBox(height: 10.sp,),
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
                  Image.asset('assets/images/Wallet.png'),
                  SizedBox(width: 2.sp,),
                  Text('Pay via wallet',style: TextStyle(fontSize: 20.sp),),
                  Spacer(),
                  Text('\$26.00',style: TextStyle(fontSize: 20  .sp),),
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
       title: Text('Confirm Payment',style: TextStyle(color: AppColors.white),),
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
                      hintText: 'Write your comments...',
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
                  'assets/images/thankyou.png',
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
                  //  fontWeight: FontWeight.bold,
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
                   Get.to(HomePage()); // Close the dialog
                  },
                  title: Text('Back to Home', style: TextStyle(fontSize: 20, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
