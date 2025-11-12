import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(PhoneNumber) onInputChanged;
  final Function(bool) onInputValidated;
  final PhoneNumber initialValue;

  PhoneNumberInput({
    required this.controller,
    required this.onInputChanged,
    required this.onInputValidated,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
        leadingPadding: 0.sp,
        trailingSpace: false,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: initialValue,
      textFieldController: controller,
      formatInput: false,
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter your phone number',
        labelStyle: TextStyle(color: Color(0XFF8A8A8A)),
        hintStyle: TextStyle(color: Color(0XFF8A8A8A), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF8A8A8A), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF8A8A8A), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}