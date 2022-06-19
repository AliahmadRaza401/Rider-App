import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/All%20Screens/ConformOTP/conformOTP.dart';
import 'package:ride_star/Provider/userProvider.dart';
import 'package:ride_star/Utils/custom_toast.dart';
import 'package:ride_star/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';
import '../../Services/app_route.dart';
import '../signUp/personal_Information.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  CountryCode countryCode = CountryCode.fromDialCode('+92');
  bool loading = false;
  TextEditingController phone = TextEditingController();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  checkUserExist(context, phone) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool userExist = false;
    print('checkUser________________________________________!');
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var userNum = "0$phone";

        if (doc['userMobile'].toString() == userNum) {
          print('phone: $phone');
          preferences.setString("uid", doc['uid']);
          userExist = true;
          userProvider.userModel = MyUserModel.fromMap(doc.data());

          signIn();
        }
      });
      log("Id === ${userProvider.userModel.uid}");
      if (!userExist) {
        setState(() {
          loading = false;
        });
        ToastUtils.showCustomToast(
            context, "You account not exist \n kindly SingUp", Colors.red);
      }
    });
  }

  signIn() async {
    print("SingIn_______________________");

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
      setState(() {
        loading = false;
      });
      ToastUtils.showCustomToast(context, "Something went wrong", Colors.red);
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
              CustomWidget.heightSizedBoxWidget(30.h),
              CustomWidget.textWidget(
                  'Login', 'Encode Sans', 22.sp, FontWeight.w400, 0xff2B2B2B),
              CustomWidget.heightSizedBoxWidget(50.h),
              CustomWidget.textWidget('Enter Customer Mobile Number',
                  'Encode Sans', 18.sp, FontWeight.w800, 0xff2B2B2B),
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
                  ? const CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : InkWell(
                      onTap: () {
                        print("asdfs");
                        if (phone.text == null || phone.text.isEmpty) {
                          ToastUtils.showCustomToast(
                              context, "Enter Your Number", Colors.red);
                        } else {
                          setState(() {
                            loading = true;
                          });
                          checkUserExist(context, phone.text);
                        }
                      },
                      child: customButtonDesignWidget(context, 'Login....')),
              CustomWidget.heightSizedBoxWidget(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget.textWidget("If you don't have an account  ", '',
                      12.sp, FontWeight.w400, 0xff888888),
                  InkWell(
                    onTap: () {
                      AppRoutes.push(context, const PersonalInformation());
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

  //////////////////////////////////// Custom Button With  Arrow   ///////////////////////////
  Widget customButtonDesignWidget(
    context,
    String text,
  ) {
    return Container(
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
        ));
  }
}
