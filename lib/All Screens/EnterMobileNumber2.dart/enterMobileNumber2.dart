import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class EnterMobileNumber2 extends StatefulWidget {
  const EnterMobileNumber2({Key? key}) : super(key: key);

  @override
  State<EnterMobileNumber2> createState() => _EnterMobileNumber2State();
}

class _EnterMobileNumber2State extends State<EnterMobileNumber2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomWidget.heightSizedBoxWidget(140.h),
          const Center(
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(profileplus),
            ),
          ),
          CustomWidget.heightSizedBoxWidget(80.h),
          Align(
            alignment: Alignment.center,
            child: CustomWidget.textWidget('Refer A Friend', 'Encode Sans',
                18.sp, FontWeight.w600, 0xff2b2b2b),
          ),
          CustomWidget.heightSizedBoxWidget(80.h),
          textFormField('Enter Refer ID', profile, true, 0xff606060, 12.sp,
              FontWeight.w400, 0xffAEAEB2),
          CustomWidget.heightSizedBoxWidget(180.h),
          CustomWidget.customButtonWithoutArrowWidget(
              context, '/earning', 'Finish'),
          CustomWidget.heightSizedBoxWidget(10.h),
          Align(
            alignment: Alignment.center,
            child: CustomWidget.textWidget(
                'skip', 'Encode Sans', 16.sp, FontWeight.w600, 0xff606060),
          ),
        ],
      ),
    );
  }

  Widget textFormField(String hinttext, String prefixicon, bool keyBordType,
      hinttextcolor, hinttextsize, hinttextFontWeight, borderColor) {
    return Container(
      height: 56.h,
      width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(borderColor), width: 1),
      ),
      child: Center(
        child: TextFormField(
          // controller: myController,
          textInputAction: TextInputAction.next,
          keyboardType: keyBordType == true
              ? TextInputType.number
              : TextInputType.emailAddress,
          // // obscureText: password == true ? obscureText : false,
          // cursorColor:
          //     white == true ? AppColors.customWhite : AppColors.customBlack,
          // cursorWidth: 2.0,
          // cursorHeight: AppSizes.dynamicHeight(context, .03),
          style: TextStyle(
            color: const Color(0xff606060),
            fontSize: 12.sp,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hinttext,
            prefixIcon: Image(image: AssetImage(prefixicon)),
            hintStyle: TextStyle(
              color: Color(hinttextcolor),
              fontSize: hinttextsize,
              fontFamily: 'Encode Sans',
              fontWeight: hinttextFontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
