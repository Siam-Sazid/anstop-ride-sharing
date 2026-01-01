import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../custom_assets/app_image.dart';


class PaymentMethodDropdown extends StatefulWidget {
  @override
  _PaymentMethodDropdownState createState() => _PaymentMethodDropdownState();
}

class _PaymentMethodDropdownState extends State<PaymentMethodDropdown> {
  String _selectedPaymentMethod = 'Wallet';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayShade100),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButton<String>(
        value: _selectedPaymentMethod,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
        iconSize: 30,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue!;
          });
        },
        underline: Container(),
        dropdownColor: AppColors.white,
        items: <String>['Wallet', 'By Cards', 'By Cash']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:  8.sp),
              child: Row(
                children: [

                  Image.asset(
                    _getImageForPaymentMethod(value),
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10),
                  Text(value),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getImageForPaymentMethod(String paymentMethod) {
    switch (paymentMethod) {
      case 'Wallet':
        return AppImage.wallet;
      case 'By Cards':
        return AppImage.cards;
      case 'By Cash':
        return AppImage.cash;
      default:
        return AppImage.wallet;
    }
  }
}
