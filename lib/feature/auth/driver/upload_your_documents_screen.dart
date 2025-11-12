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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 15.h),
              Text(
                'Upload your documents',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align the first part of the text to the left
                  children: [
                    Text(
                      'please upload the required documents to complete',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(height: 4.h), // Optional: Adjust the spacing between the two lines
                    Center( // Center the second part of the text
                      child: Text(
                        'your application process',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 29.h),
              ///
              CustomBoxItems(
                documentTitle: 'National ID',
                isUploaded: true,
                onTap: () {
                  Get.offAll(() => NationalIdScreen());
                  // Handle document upload
                },
              ),

              CustomBoxItems(
                documentTitle: 'Driving Licence',
                isUploaded: false,
                onTap: () {
                  Get.offAll(() => DrivingLicenseScreen());
                  // Handle document upload
                },
              ),
              CustomBoxItems(
                documentTitle: 'Car information',
                isUploaded: true,
                onTap: () {
                  Get.offAll(() => CarInformationScreen());
                  // Handle document upload
                },
              ),
              CustomBoxItems(
                documentTitle: 'Your Picture',
                isUploaded: true,
                onTap: () {
                  Get.offAll(() => UploadProfilePictureScreen());
                  // Handle document upload
                },
              ),
              SizedBox(height: 250.sp),
             // Spacer(),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.sp),
                child: CustomButton(onPressed: () {}, label: 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
