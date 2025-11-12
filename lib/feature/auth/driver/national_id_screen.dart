import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';



class NationalIdScreen extends StatefulWidget {
  const NationalIdScreen({super.key});

  @override
  State<NationalIdScreen> createState() => _NationalIdScreenState();
}

class _NationalIdScreenState extends State<NationalIdScreen> {
  /// Controller are define here
  final TextEditingController _nationalIdTEController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.sp ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 20.h),
                Text(
                  'National ID',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 29.h),
                ///
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.sp),
                    child: Text(
                      'National Id number',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),

                CustomTextField(
                  controller: _nationalIdTEController,

                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.sp),
                  child: Text(
                    'Upload your National ID picture (Front)',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 12.h),
                CustomUploadItems(
                  borderWidth: 2.0,
                  borderColor: Colors.black,
                  child: Container(
                    color: Colors.white,

                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.sp),
                  child: Text(
                    'Upload your National ID picture (Front)',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 12.h),
                CustomUploadItems(
                  borderWidth: 2.0,
                  borderColor: Colors.black,
                  child: Container(
                    color: Colors.white,

                  ),
                ),
                SizedBox(height: 55.h),

               // SizedBox(height: 250.sp),
                // Spacer(),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 5.sp),
                  child: CustomButton(onPressed: () {}, label: 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
