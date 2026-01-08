import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/auth/driver/car_information_screen.dart';
import 'package:ride_sharing/feature/auth/driver/driving_license_screen.dart';
import 'package:ride_sharing/feature/auth/driver/national_id_screen.dart';
import 'package:ride_sharing/feature/auth/driver/upload_profile_picture.dart';
import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class UploadYourDocuments extends StatefulWidget {
  const UploadYourDocuments({super.key});

  @override
  State<UploadYourDocuments> createState() => _UploadYourDocumentsState();
}

class _UploadYourDocumentsState extends State<UploadYourDocuments> {
  /// Controller are define here
  final TextEditingController _nameTEController = TextEditingController();
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
        child: CustomButton(onPressed: () {}, label: AppString.submitButton),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 15.h),
              Text(
                AppString.uploadDocumentsTitle,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align the first part of the text to the left
                  children: [
                    Text(
                      AppString.uploadDocumentsMessage1,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(height: 4.h), // Optional: Adjust the spacing between the two lines
                    Center( // Center the second part of the text
                      child: Text(
                        AppString.uploadDocumentsMessage2,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 29.h),
              ///
              CustomBoxItems(
                documentTitle: AppString.nationalIdLabel,
                isUploaded: false,
                onTap: () {
                  Get.to(() => NationalIdScreen());
                  // Handle document upload
                },
              ),

              CustomBoxItems(
                documentTitle: AppString.drivingLicenceLabel,
                isUploaded: false,
                onTap: () {
                  Get.to(() => DrivingLicenseScreen());
                  // Handle document upload
                },
              ),
              CustomBoxItems(
                documentTitle: AppString.carInformationLabel,
                isUploaded: false,
                onTap: () {
                  Get.to(() => CarInformationScreen());
                  // Handle document upload
                },
              ),
              CustomBoxItems(
                documentTitle: AppString.yourPictureLabel,
                isUploaded: false,
                onTap: () {
                  Get.to(() => UploadProfilePictureScreen());
                  // Handle document upload
                },
              ),
              SizedBox(height: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
