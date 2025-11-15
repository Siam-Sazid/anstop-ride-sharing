import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/logo.dart';

class BookingCarsBottomSheet extends StatefulWidget {
  @override
  _BookingCarsBottomSheetState createState() => _BookingCarsBottomSheetState();
}

class _BookingCarsBottomSheetState extends State<BookingCarsBottomSheet> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      color: AppColors.white,
      //  padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Driver is on the way to pick up',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 50,
                color: Colors.black,
                  child: Center(child: Text('1 min',style: TextStyle(color: AppColors.white),)),
                  
                )
              ],
            ),
          ),

          SizedBox(height: 16.sp),
          Container(
            color:AppColors.violetShade,
            child: ListTile(
              title: Text('DHK METRO - 8475Dkk'),
              subtitle: Text('Toyota'),
              trailing: Image.asset('assets/images/cars_side_view.png'),
            ),
          ),


          // User Info Section with Avatar and Rating
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    'https://picsum.photos/250?image=9', // Placeholder Image URL
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.sp),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    // Rating Stars
                    Row(
                      children: [

                      ]
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\$24"), // Price
                    Text('28 km') // Distance
                  ],
                )
              ],
            ),
          ),

          Container(
            width: double.infinity,
            child: Divider(
              color: Colors.grey[200],
              thickness: 15, // Increased thickness
              indent: 0,
              endIndent: 0,
            ),
          ),

          SizedBox(height: 8.sp),

          // Start and End Location Information
          
          // SizedBox(height: 8.sp),
          // SizedBox(width: 12.sp),


          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryColor),
              SizedBox(width: 5.sp),
              Text('Green Road, Dhaka'), // Destination location
            ],
          ),

          SizedBox(height: 8.sp),

          // Distance Information
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Distance'),
                Spacer(),
                Text('29 km') // Distance Value
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Divider(
              color: Colors.grey[200],
              thickness: 15, // Increased thickness
              indent: 0,
              endIndent: 0,
            ),
          ),
          SizedBox(height: 8.sp),

          Row(
            children: [
              Image.asset('assets/images/Wallet.png'),
              SizedBox(width: 2.sp,),
              Text('Pay via wallet',style: TextStyle(fontSize: 20.sp),)
            ],
          ),
          Container(
            width: double.infinity,
            child: Divider(
              color: Colors.grey[200],
              thickness: 15, // Increased thickness
              indent: 0,
              endIndent: 0,
            ),
          ),
          // Cancel Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cancel this ride?'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return BookingCarsBottomSheet();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red, // Background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Border radius
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Make the row size fit the content
                    children: [

                      // Space between the icon and the text
                      Text(
                        'Cancel Now',
                        style: TextStyle(
                          color: Colors.white, // Text color
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.close,
                        color: Colors.white, // Icon color
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
