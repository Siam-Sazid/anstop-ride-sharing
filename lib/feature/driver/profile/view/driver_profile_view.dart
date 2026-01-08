import 'package:ride_sharing/feature/auth/driver/upload_your_documents_screen.dart';
import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/utils/driver/driver_custom_drawer.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';

class DriverProfileView extends StatefulWidget {
  const DriverProfileView({super.key});

  @override
  State<DriverProfileView> createState() => _DriverProfileViewState();
}

class _DriverProfileViewState extends State<DriverProfileView> {
  /// Controller are define here
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();




  bool isChecked = false;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');
  DateTime? _selectedDate;
  final List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;

  Future<void> _selectGender(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double textFieldWidth = renderBox.size.width;
    final double textFieldHeight = renderBox.size.height;
    final double middleY = position.dy + (textFieldHeight / 2);
    final String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + textFieldWidth - 24,
        middleY + 30,
        position.dx + textFieldWidth - 24,
        0,),
      items: _genders.map((gender) {
        return PopupMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
    );

    if (selected != null) {
      setState(() {
        _selectedGender = selected;
        _genderController.text = _selectedGender!;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = '${_selectedDate?.toLocal()}'.split(' ')[0];
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MessagingColors.profileBackgroundColor,
      key: _scaffoldKey,
      appBar: CustomAppBarTitle(scaffoldKey: _scaffoldKey,title: L10n.tr.profileTitle,),
      drawer: DriverCustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 46.h),
              Stack(
                alignment: Alignment.bottomLeft, // Positions child at bottom-left
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 100.h,
                      height: 100.h,
                      child: Image.network(
                        'https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,  // Adjust spacing from bottom
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit,
                        color: Colors.green[800],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 29.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameTEController,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: L10n.tr.nameLabel,
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: _emailTEController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: L10n.tr.emailLabel,
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      PhoneNumberInput(
                        controller: _phoneNumberController,
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            _phoneNumber = number;
                          });
                        },
                        onInputValidated: (bool value) {
                          print(value ? 'Valid number' : 'Invalid number');
                        },
                        initialValue: _phoneNumber,
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _birthdayController,
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0XFF8A8A8A),
                              size: 24.sp,
                            ),
                            hintText: L10n.tr.selectBirthdayHint,
                            hintextSize: 14.sp,
                            hintextColor: Color(0XFF8A8A8A),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () async {
                          // Show dropdown when text field is tapped
                          _selectGender(context);
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _genderController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0XFF8A8A8A),
                                size: 24,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color(0XFF8A8A8A),
                                size: 24,
                              ),
                              hintText: L10n.tr.genderHintText,
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0XFF8A8A8A),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0XFF8A8A8A),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0XFF8A8A8A),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: _addressTEController,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: L10n.tr.addressHintText,
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        isObscureText: true,
                        isPassword: true,
                        controller: _passwordTEController,
                        prefixIcon: Icon(
                          Icons.key,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: L10n.tr.enterPasswordHintText,
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        isObscureText: true,
                        isPassword: true,
                        controller: _confirmPasswordTEController,
                        prefixIcon: Icon(
                          Icons.key,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: L10n.tr.enterPasswordHintText,
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),

                      SizedBox(height: 17.5.sp),
                      CustomButton(onPressed: () {
                        Get.offAll(() => UploadYourDocuments());

                      }, label: 'Save Changes'),
                      SizedBox(height: 16.h),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
