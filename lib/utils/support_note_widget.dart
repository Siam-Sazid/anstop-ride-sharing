import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/messages/view/message_list_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class SupportNoteWidget extends StatelessWidget {


  // Constructor
   SupportNoteWidget({
    Key? key,

  }) : super(key: key);
  final TextEditingController supportNoteTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          children: [
            Expanded(child: CustomTextField(
              controller: supportNoteTEController,
              prefixIcon: GestureDetector(
                onTap: (){},
                child: Icon(CupertinoIcons.chat_bubble_2,
                  color: AppColors.togglebuttonColor,),
              ),
              borderRadio: 20,
            )
            ),
            SizedBox(width: 8.sp,),
            GestureDetector(
              onTap: (){
                Get.to(() => MessagesListScreen());
              },
                child: Icon(Icons.chat_bubble_outline_outlined,
                  color: AppColors.togglebuttonColor,
                )
            ),
            SizedBox(width: 8.sp,),
            Icon(Icons.phone,color: AppColors.togglebuttonColor,),


          ],
        ),
      ),
    );
  }
}
