import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_star/All%20Screens/ConformOTP/conformOTP.dart';
import 'package:ride_star/All%20Screens/signUp/personal_Information.dart';
import 'package:ride_star/Routes/routes.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Utils/custom_toast.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class EnterMobileNumber extends StatefulWidget {
  const EnterMobileNumber({Key? key}) : super(key: key);

  @override
  State<EnterMobileNumber> createState() => _EnterMobileNumberState();
}

class _EnterMobileNumberState extends State<EnterMobileNumber> {
  CountryCode countryCode = CountryCode.fromDialCode('+92');
  bool loading = false;
  TextEditingController phone = TextEditingController();
  signIn() async {
    print("SingIn");
    if (phone.text == null || phone.text.isEmpty) {
      ToastUtils.showCustomToast(context, "Enter Your Number", Colors.red);
    } else {
      setState(() {
        loading = true;
      });
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: countryCode.toString() +
              phone.text.toString().replaceAll(RegExp(r'^0+(?=.)'), ''),
          verificationCompleted: (PhoneAuthCredential credential) async {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
            ToastUtils.showCustomToast(
                context, "Verification Complete", Colors.green);
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Verification Complete e: $e');
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
            ToastUtils.showCustomToast(context, e.code.toString(), Colors.red);
          },
          codeSent: (String verificationId, int? resendToken) {
            ToastUtils.showCustomToast(context, "Code Sent", Colors.green);
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
            AppRoutes.push(
                context,
                ConformOTP(
                  phone: countryCode.toString() +
                      phone.text
                          .toString()
                          .replaceAll(RegExp(r'^0+(?=.)'), '')
                          .toString(),
                  isTimeOut2: false,
                  verifyId: verificationId.toString(),
                ));
            // AppRoutes.push(
            //   context,
            //   ChatOtpScreen(
            //       isTimeOut2: false,
            //       phone: countryCode.toString() +
            //           phone.text
            //               .toString()
            //               .replaceAll(RegExp(r'^0+(?=.)'), '')
            //               .toString(),
            //       verifyId: verificationId),
            // );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
          },
        );
      } catch (e) {
        print('e: $e');
        ToastUtils.showCustomToast(context, "Something went wrong", Colors.red);
      }
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r)),
                    width: 100.w,
                    child: CountryCodePicker(
                      textStyle: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black),
                      padding: const EdgeInsets.all(0),
                      onChanged: (code) {
                        if (mounted) {
                          setState(() {
                            countryCode = code;
                          });
                        }
                      },
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: false,
                      initialSelection: countryCode.dialCode,
                    ),
                  ),
                  Container(
                    width: 190.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r)),
                    child: TextFormField(
                        controller: phone,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                            fontSize: 16.sp, color: Colors.black),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              left: 20),
                          labelStyle: GoogleFonts.rubik(
                              fontSize: 16.sp, color: Colors.black),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "XXX-XXX-XXXX",
                          hintStyle: GoogleFonts.rubik(
                              fontSize: 16.sp, color: Colors.black),
                        )),
                  ),
                ],
              ),
              CustomWidget.heightSizedBoxWidget(120.h),
              loading
                  ? CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : customButtonDesignWidget(context, 'Get OTP'),
              CustomWidget.heightSizedBoxWidget(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget.textWidget("If you don't have an account  ", '',
                      12.sp, FontWeight.w400, 0xff888888),
                  InkWell(
                    onTap: () {
                      AppRoutes.push(context, PersonalInformation());
                    },
                    child: CustomWidget.textWidget(
                        "SignUp", '', 16.sp, FontWeight.bold, 0xff2B2B2B),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget textFormField(String hinttext, String prefixicon, bool keyBordType,
  //     hinttextcolor, hinttextsize, hinttextFontWeight, borderColor) {
  //   return Container(
  //     height: 56.h,
  //     width: 323.w,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10.r),
  //       border: Border.all(color: Color(borderColor), width: 1),
  //     ),
  //     child: Center(
  //       child: TextFormField(
  //         controller: numberController,
  //         textInputAction: TextInputAction.next,
  //         keyboardType: keyBordType == true
  //             ? TextInputType.number
  //             : TextInputType.emailAddress,
  //         // // obscureText: password == true ? obscureText : false,
  //         // cursorColor:
  //         //     white == true ? AppColors.customWhite : AppColors.customBlack,
  //         // cursorWidth: 2.0,
  //         // cursorHeight: AppSizes.dynamicHeight(context, .03),
  //         style: TextStyle(
  //           color: const Color(0xff606060),
  //           fontSize: 12.sp,
  //           fontFamily: 'Encode Sans',
  //           fontWeight: FontWeight.w400,
  //         ),
  //         decoration: InputDecoration(
  //           border: InputBorder.none,
  //           hintText: hinttext,
  //           prefixIcon: Image(image: AssetImage(prefixicon)),
  //           hintStyle: TextStyle(
  //             color: Color(hinttextcolor),
  //             fontSize: hinttextsize,
  //             fontFamily: 'Encode Sans',
  //             fontWeight: hinttextFontWeight,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //////////////////////////////////// Custom Button With  Arrow   ///////////////////////////
  customButtonDesignWidget(
    context,
    String text,
  ) {
    return InkWell(
      onTap: () {
        signIn();
      },
      child: Container(
          height: 56.h,
          width: 323.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            // color: const Color(0xffCE1A17),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffEAC4C7),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.55),
              ),
            ],
            color: const Color(0xffCE1A17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Encode Sans'),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xffFFFFFF),
              )
            ],
          )),
    );
  }
}
