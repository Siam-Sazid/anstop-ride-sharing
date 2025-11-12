import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class PassengerRegistration extends StatefulWidget {
  const PassengerRegistration({super.key});

  @override
  State<PassengerRegistration> createState() => _PassengerRegistrationState();
}

class _PassengerRegistrationState extends State<PassengerRegistration> {
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
              SizedBox(height: 24.h),
              Center(child: LogoWidget()),
              SizedBox(height: 15.h),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),
              Text(
                'Fill the information to create a new account.',
                style: TextStyle(fontSize: 12.sp),
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
                        hintText: 'Name here',
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: _nameTEController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: 'Enter E-mail',
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        isObscureText: true,
                        isPassword: true,
                        controller: _nameTEController,
                        prefixIcon: Icon(
                          Icons.key,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: 'Enter Password',
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        isObscureText: true,
                        isPassword: true,
                        controller: _nameTEController,
                        prefixIcon: Icon(
                          Icons.key,
                          color: Color(0XFF8A8A8A),
                          size: 24.sp,
                        ),
                        hintText: 'Enter Password',
                        hintextSize: 14.sp,
                        hintextColor: Color(0XFF8A8A8A),
                      ),
                      SizedBox(height: 46.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            // fillColor: Color(0XFF323232),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Agree with ', style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF4E4E4E),
                                ),
                                ),
                                WidgetSpan(child: GestureDetector(
                                  child: Text('Terms of Service', style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      decorationThickness: 2,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red
                                  )),
                                  onTap: ()=> {
                                    Get.to(() => TermsOfServices())
                                  },
                                )),
                                TextSpan(text: ' & ', style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF4E4E4E),
                                )),
                                TextSpan(
                                    text: 'Privacy Policy', style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                    decorationThickness: 2,
                                    decoration: TextDecoration.underline
                                )),
                              ],
                            ),
                          )
                        ],
                      )
                      ,
                      SizedBox(height: 17.5.sp),
                      CustomButton(onPressed: () {}, label: 'Register'),
                      SizedBox(height: 16.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Have any account ?', style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF4E4E4E),
                            )),
                            TextSpan(text: ' Login', style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                                decorationThickness: 2,
                                decoration: TextDecoration.underline
                            )),
                          ],
                        ),
                      ),
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
