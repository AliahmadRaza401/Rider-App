// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:ride_star/Utils/custom_toast.dart';

// import '../../Custom Widgets/customWidgets.dart';

// class LogInScreenConformOTP extends StatefulWidget {
//   String phone;
//   // bool isTimeOut2;
//   String verifyId;
//   LogInScreenConformOTP({
//     Key? key,
//     required this.phone,
//     required this.verifyId,
//     // required this.isTimeOut2,
//   }) : super(key: key);

//   @override
//   State<LogInScreenConformOTP> createState() => _LogInScreenConformOTPState();
// }

// class _LogInScreenConformOTPState extends State<LogInScreenConformOTP> {
//   bool loading = false;
//   TextEditingController otpConttl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffE5E5E5),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         padding: EdgeInsets.only(left: 26.w, right: 26.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: CustomWidget.textWidget('Confirm PIN Number',
//                   'Encode Sans', 16.sp, FontWeight.w700, 0xff2B2B2B),
//             ),
//             CustomWidget.heightSizedBoxWidget(50.h),
//             PinCodeTextField(
//               controller: otpConttl,
//               appContext: context,
//               pastedTextStyle: TextStyle(
//                 color: Colors.green.shade600,
//                 fontWeight: FontWeight.bold,
//               ),
//               length: 6,
//               // obscureText: true1234444,
//               // obscuringCharacter: '*',
//               // obscuringWidget: const FlutterLogo(
//               //   size: 24,
//               // ),
//               blinkWhenObscuring: true,
//               animationType: AnimationType.fade,
//               validator: (v) {
//                 if (v!.length < 3) {
//                   return "I'm from validator";
//                 } else {
//                   return null;
//                 }
//               },
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(5),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//                 activeFillColor: Colors.white,
//               ),
//               cursorColor: Colors.black,
//               animationDuration: const Duration(milliseconds: 300),
//               enableActiveFill: true,
//               // errorAnimationController: errorController,
//               // controller: textEditingController,
//               keyboardType: TextInputType.number,
//               boxShadows: const [
//                 BoxShadow(
//                   offset: Offset(0, 1),
//                   color: Colors.black12,
//                   blurRadius: 10,
//                 )
//               ],
//               onCompleted: (v) {
//                 debugPrint("Completed");
//               },
//               // onTap: () {
//               //   print("Pressed");
//               // },
//               onChanged: (value) {
//                 debugPrint(value);
//                 // setState(() {
//                 //   currentText = value;
//                 // });
//               },
//               beforeTextPaste: (text) {
//                 debugPrint("Allowing to paste $text");
//                 //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                 //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                 return true;
//               },
//             ),
//             CustomWidget.heightSizedBoxWidget(130.h),
//             loading
//                 ? CircularProgressIndicator(
//                     color: Colors.red,
//                   )
//                 : customButtonDesignWidget(context, 'Confirm'),
//           ],
//         ),
//       ),
//     );
//   }

//   customButtonDesignWidget(
//     context,
//     String text,
//   ) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//           height: 56.h,
//           width: 323.w,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.sp),
//             // color: const Color(0xffCE1A17),
//             boxShadow: const <BoxShadow>[
//               BoxShadow(
//                 color: Color(0xffEAC4C7),
//                 blurRadius: 15.0,
//                 offset: Offset(0.0, 0.55),
//               ),
//             ],
//             color: const Color(0xffCE1A17),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 text,
//                 style: TextStyle(
//                     color: const Color(0xffFFFFFF),
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Encode Sans'),
//               ),
//               const Icon(
//                 Icons.arrow_forward,
//                 color: Color(0xffFFFFFF),
//               )
//             ],
//           )),
//     );
//   }
// }
