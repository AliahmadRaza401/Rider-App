import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class EnterMobileNumber extends StatefulWidget {
  const EnterMobileNumber({Key? key}) : super(key: key);

  @override
  State<EnterMobileNumber> createState() => _EnterMobileNumberState();
}

class _EnterMobileNumberState extends State<EnterMobileNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.heightSizedBoxWidget(160.h),
              const Center(
                child: Image(
                  image: AssetImage(profilefaty),
                ),
              ),
              CustomWidget.heightSizedBoxWidget(100.h),
              CustomWidget.textWidget('Enter Customer Mobile Number',
                  'Encode Sans', 18.sp, FontWeight.w800, 0xff2B2B2B),
              CustomWidget.heightSizedBoxWidget(10.h),
              CustomWidget.textWidget('we will sand a otp number',
                  'Encode Sans', 12.sp, FontWeight.w400, 0xff888888),
              CustomWidget.heightSizedBoxWidget(60.h),
              textFormField('Enter mobile number', phone, true, 0xff606060,
                  12.sp, FontWeight.w400, 0xffAEAEB2),
              CustomWidget.heightSizedBoxWidget(120.h),
              CustomWidget.customButtonWithoutArrowWidget(
                  context, '/conformOTP', 'Get OTP'),
            ],
          ),
        ),
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
