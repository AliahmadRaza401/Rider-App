import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/Provider/authenticationProvider.dart';
import 'package:ride_star/Services/imagPicker.dart';

import '../../Custom Widgets/customWidgets.dart';
import '../../Images/images.dart';

class EnlistmentCertificate extends StatefulWidget {
  const EnlistmentCertificate({Key? key}) : super(key: key);

  @override
  State<EnlistmentCertificate> createState() => _EnlistmentCertificateState();
}

class _EnlistmentCertificateState extends State<EnlistmentCertificate> {
  bool loading = false;
  
  UserProfileProvider userProfileProvider = UserProfileProvider();
  final formKey = GlobalKey<FormState>();
  PlatformFile? card1;
  TextEditingController enlistmentNumberController = TextEditingController();
  //  UserProfileProvider userProfileProvider = UserProfileProvider();

  @override
  void initState() {
    // userProfileProvider =
    //     Provider.of<UserProfileProvider>(context, listen: false);
    super.initState();
  }

  DateTime? datepicker;
  DateTime selectedDate1 = DateTime.now();
  String selectedDate = '';
  selectDate(
    BuildContext context,
    // StateSetter dropsetState,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime.now().subtract(Duration(days: 182)),
      lastDate: DateTime.now(),
      helpText: "SELECT FROM DATE",
      fieldHintText: "YEAR/MONTH/DATE",
      fieldLabelText: "FROM DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white, // header text color
              onSurface: Colors.green, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.green, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDate1) {
      setState(() {
        selectedDate1 = selected;
        final format = DateFormat('yyyy-MM-dd');
        selectedDate = "${format.format(selectedDate1).toString()}";
      });
    } else if (selected != null && selected == selectedDate1) {
      setState(() {
        selectedDate1 = selected;
        final format = DateFormat('yyyy-MM-dd');
        selectedDate = "${format.format(selectedDate1).toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool loading = Provider.of<UserProfileProvider>(context).loading;
    return Scaffold(
      appBar: CustomWidget.setAppBar(
        context,
        true,
        'Enlistment Certificate',
        0xff2B2B2B,
        FontWeight.w600,
        'Encode Sans',
        18.sp,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(20.h),
            Center(
              child: CustomWidget.textWidget('Enlistment certificate image ',
                  'Encode Sans', 12.sp, FontWeight.w400, 0xff888888),
            ),
            CustomWidget.heightSizedBoxWidget(5.h),
            GestureDetector(
              onTap: () async {
                openFilePicker();
              },
              child: _image != null
                  ? Container(
                      height: 202.h,
                      width: 323.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xff888888)),
                        image: DecorationImage(
                          image: FileImage(
                            _image!,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container(
                      height: 202.h,
                      width: 323.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(card),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
            CustomWidget.heightSizedBoxWidget(20.h),
            textFormField(
              'Enlistment Certificate Number',
              nidcard,
              true,
              0xff606060,
              12.sp,
              FontWeight.w400,
              0xffAEAEB2,
              enlistmentNumberController,
            ),
            CustomWidget.heightSizedBoxWidget(45.h),
            InkWell(
              onTap: () {
                selectDate(context);
              },
              child: Container(
                height: 56.h,
                width: 323.w,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xffAEAEB2), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // datepicker == null
                    //     ?
                    CustomWidget.textWidget(
                        selectedDate == null
                            ? 'Enlistment Certificate Expiry Date'
                            : selectedDate,
                        'Encode Sans',
                        12.sp,
                        FontWeight.w700,
                        0xff606060),

                    // : Text(datepicker.toString()),
                    const Image(image: AssetImage(calender)),
                  ],
                ),
              ),
            ),
            CustomWidget.heightSizedBoxWidget(90.h),
            loading == true
                ? const CircularProgressIndicator(
                    color: Colors.red,
                  )
                : InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate() &&
                          _image != null &&
                          selectedDate.isNotEmpty) {
                        userProfileProvider.enlistmentCertificateNumber =
                            enlistmentNumberController.text;
                        userProfileProvider.enlistmentCertificateExpiryDate =
                            selectedDate;
                        userProfileProvider.enlistmentCertificateImage = _image;

                        userProfileProvider.postDetailsToFirestore(context);
                        // Navigator.pushNamed(context, '/home');
                      } else {
                        print('Is  Not Velidate');
                      }
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
                              "SignUp ",
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
                  ),
            // CustomWidget.customButtonWidget(context, '/home', 'Next  '),
          ],
        ),
      )),
    );
  }

  File? _image;
  Future<void> openFilePicker() async {
    print("File Picker");
    var image = await pickImageFromGalleryOrCamera(context);
    if (image == null) return;

    setState(() => _image = image);
    // cropImage(image);
  }

  /// Crop Image
  cropImage(filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  Widget textFormField(
      String hinttext,
      String prefixicon,
      bool keyBordType,
      hinttextcolor,
      hinttextsize,
      hinttextFontWeight,
      borderColor,
      controllerName) {
    return Container(
      height: 56.h,
      width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(borderColor), width: 1),
      ),
      padding: EdgeInsets.all(1.h),
      child: Center(
        child: TextFormField(
          controller: controllerName,
          textInputAction: TextInputAction.next,
          keyboardType: keyBordType == true
              ? TextInputType.number
              : TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field is required";
            } else {
              return null;
            }
          },
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
