import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/car_booking/utils/cancel_driver_widget.dart';
import 'package:ride_sharing/feature/car_booking/utils/support_note_widget.dart';
import 'package:ride_sharing/feature/car_booking/utils/user_info_card.dart';
import 'package:ride_sharing/feature/car_booking/utils/user_info_section.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_vertical_line.dart';
import '../../../app/utils/app_colors.dart';

class OngoingTripDetails extends StatelessWidget {
  const OngoingTripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Trip Details"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:  16.0,vertical: 8.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Map image container
              Card(
                elevation: 2,
                child: ClipRRect(
          
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text("Map image not available"));
                    },
                  ),
                ),
              ),
          
              SizedBox(height: 2.h),
              Card(
                elevation: 2,
                color: AppColors.white,
                child: Container(
                  height: 85.h,
                  child: Padding(
                    padding:  EdgeInsets.all(16.sp),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Siam',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                            Spacer(),
                            Text('26th December',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Ongoing',style: TextStyle(color: Colors.green),),
                            Spacer(),
                            Text('9:00 pm') ,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /// Add other trip detail widgets here...
              Card(
                color: AppColors.white,
                elevation: 2,
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Trip',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 8.sp,),
                      Row(children: [
                        Container(
                          child: Image.asset('assets/images/greetings.png'),
                        ),
                        SizedBox(width: 5.sp,),
                        Text('Block b / Banasree, Dhaka'),
          
                      ],),
                      CustomVerticalLine(height: 20.h, color: Colors.black),
                      Row(children: [
                        Container(
                          child: Icon(Icons.location_on,color: AppColors.primaryColor,),
                        ),
                        SizedBox(width: 5.sp,),
                        Text('Green Road Dhaka'),
          
                      ],),
                      SizedBox(height: 8.sp,),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance',style: TextStyle(
                              fontSize: 18.sp,color: Colors.black
                          ),
                          ),
                          SizedBox(width: 5.sp,),
                          Text('89 km'),
          
                        ],),
                   //   SizedBox(height: 8.h,),
          
          
                      // SizedBox(height: 8.h,),
          
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
          

              Card(
                elevation: 2,
                color: AppColors.white,
                child: Container(
                  height: 36.h,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:  16.sp),
                    child: Row(
                      children: [
                        Text('Ride value'),
                        Spacer(),
                        Text('\$ 25.69') ,
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Card(
                color: AppColors.white,
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      UserInfoSection(
                        imageUrl: 'https://picsum.photos/250?image=9',
                        name: 'John Doe',
                        rating: 3.54,
                        trips: 3,
                        profession: 'Professional',
                        price: '\$24',
                        distance: '28 km',
                      ),
                      SupportNoteWidget(),
          

                    ],
                  ),
                ),
              ),
              Card(
                color: AppColors.white,
                child: CancelDriverWidget(onCancelPressed: (){

                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
