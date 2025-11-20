import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/driver/profile/view/driver_profile_view.dart';
class CustomUserRating extends StatefulWidget {
  final String name;
  final String imageUrl;
 // final double price;
 // final double distance;

  const CustomUserRating({
    Key? key,
    required this.name,
    required this.imageUrl,
   // required this.price,
  //  required this.distance,
  }) : super(key: key);

  @override
  State<CustomUserRating> createState() => _CustomUserRatingState();
}

class _CustomUserRatingState extends State<CustomUserRating> {
  int rating = 4; // Default rating

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:  8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ClipOval(
            child: Image.network(
              widget.imageUrl,
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12.sp),

          // Name + Rating Stars
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.sp,),
              GestureDetector(
                onTap: (){
                  Get.to(DriverProfileView());
                },
                  child: Text('Go to profile ',style: TextStyle(color: Colors.green,fontSize: 10.sp),

                  )

              ),
              SizedBox(height: 2.sp,),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: index < rating ? Colors.yellow : Colors.grey,
                      size: 16.sp,
                    ),
                  );
                }),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
