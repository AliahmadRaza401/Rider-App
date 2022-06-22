import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_star/All%20Screens/Home/home.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Services/shared_pref.dart';
import 'package:ride_star/Utils/custom_toast.dart';

class ConformOTP extends StatefulWidget {
  String phone;
  bool isTimeOut2;
  String verifyId;
  ConformOTP(
      {Key? key,
      required this.phone,
      required this.verifyId,
      required this.isTimeOut2})
      : super(key: key);

  @override
  State<ConformOTP> createState() => _ConformOTPState();
}

class _ConformOTPState extends State<ConformOTP> {
  bool loading = false;
  TextEditingController otpConttl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Container(
        padding: EdgeInsets.only(left: 26.w, right: 26.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CustomWidget.textWidget('Confirm PIN Number',
                  'Encode Sans', 16.sp, FontWeight.w700, 0xff2B2B2B),
            ),
            CustomWidget.heightSizedBoxWidget(50.h),
            PinCodeTextField(
              controller: otpConttl,
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                if (v!.length < 3) {
                  return "I'm from validator";
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                debugPrint("Completed");
              },
              onChanged: (value) {
                debugPrint(value);
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                return true;
              },
            ),
            CustomWidget.heightSizedBoxWidget(130.h),
            loading
                ? CircularProgressIndicator(
                    color: Colors.red,
                  )
                : customButtonDesignWidget(context, 'Confirm'),
          ],
        ),
      ),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        print('authCredential: ${authCredential.user}');
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        SharedPref.userLoggedIn(true);
        SharedPref.saveUserId(authCredential.user!.uid.toString());
        AppRoutes.push(context, Home());
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, e.message.toString(), Colors.red);
    }
  }

  customButtonDesignWidget(
    context,
    String text,
  ) {
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
            loading = true;
          });
        }
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: widget.verifyId, smsCode: otpConttl.text);

        signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      child: Container(
          height: 56.h,
          width: 323.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
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
