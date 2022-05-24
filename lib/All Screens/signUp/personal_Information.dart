import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:ride_star/Provider/authenticationProvider.dart';
import 'package:ride_star/Services/imagPicker.dart';
import 'package:ride_star/Utils/appColors.dart';

import '../../Images/images.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // PlatformFile? file;
  TextEditingController enterFullNameController = TextEditingController();
  TextEditingController enterMobileNumberController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  UserProfileProvider userProfileProvider = UserProfileProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
  }

  // File? _image;
  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    userProfileProvider.enlistmentCertificateNumber = "sdfsdfsd";
    return Scaffold(
      backgroundColor: ColorsX.screenBackgrounde,
      appBar: CustomWidget.setAppBar(
        context,
        false,
        'Personal Information',
        0xff2B2B2B,
        FontWeight.w600,
        'Encode Sans',
        18.sp,
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 26.w,
          right: 26.w,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomWidget.heightSizedBoxWidget(40.h),
                // FlatButton(onPressed: () => getImage(), child: Text('Press me')),
                // Flexible(
                //     child:
                //         _image != null ? Image.file(_image!) : Text('no Image')),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      openFilePicker();
                    },
                    child: _image != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(_image!),
                          )
                        : Image.asset(pictureframe),
                  ),
                ),
                CustomWidget.heightSizedBoxWidget(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget.textWidget('Upload Photo', 'Encode Sans',
                        12.sp, FontWeight.w700, 0xff0055cfa),
                    CustomWidget.widthSizedBoxWidget(5.w),
                    const Image(image: AssetImage(uploadcloud)),
                  ],
                ),
                CustomWidget.heightSizedBoxWidget(30.h),
                textFormField(
                    'Enter full name',
                    profile,
                    false,
                    0xff606060,
                    12.sp,
                    FontWeight.w400,
                    0xffAEAEB2,
                    enterFullNameController),
                CustomWidget.heightSizedBoxWidget(15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(image: AssetImage(info)),
                    CustomWidget.widthSizedBoxWidget(3.w),
                    CustomWidget.textWidget('Same as NID Card', 'Encode Sans',
                        12.sp, FontWeight.w400, 0xff606060),
                  ],
                ),
                CustomWidget.heightSizedBoxWidget(20.h),
                textFormField(
                  'Enter mobile number',
                  phone,
                  true,
                  0xff606060,
                  12.sp,
                  FontWeight.w400,
                  0xffAEAEB2,
                  enterMobileNumberController,
                ),
                CustomWidget.heightSizedBoxWidget(40.h),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomWidget.textWidget('Select vehicle',
                        'Encode Sans', 18.sp, FontWeight.w600, 0xff2b2b2b)),
                CustomWidget.heightSizedBoxWidget(20.h),
                textFormField(
                  'Bike',
                  bicke,
                  false,
                  0xffCE1A17,
                  16.sp,
                  FontWeight.w700,
                  0xffce1a17,
                  vehicleController,
                ),
                CustomWidget.heightSizedBoxWidget(100.h),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate() && _image != null) {
                      print(_image!.path);
                      userProfileProvider.personalName =
                          enterFullNameController.text;
                      userProfileProvider.personalMobileNumber =
                          enterMobileNumberController.text;
                      userProfileProvider.personalVehicle =
                          vehicleController.text;
                      print(userProfileProvider.personalName);
                      print(userProfileProvider.personalMobileNumber);
                      print(userProfileProvider.personalVehicle);
                      Navigator.pushNamed(context, '/nationaIDCardScreen');
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
                            "Next",
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
              ],
            ),
          ),
        ),
      ),
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
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
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
    controllerName,
  ) {
    return Container(
      height: 56.h,
      width: 323.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(borderColor), width: 1),
      ),
      child: Center(
        child: TextFormField(
          controller: controllerName,

          textInputAction: TextInputAction.next,
          keyboardType: keyBordType == true
              ? TextInputType.number
              : TextInputType.emailAddress,

          // // obscureText: password == true ? obscureText : false,
          // cursorColor:
          //     white == true ? AppColors.customWhite : AppColors.customBlack,
          // cursorWidth: 2.0,
          // cursorHeight: AppSizes.dynamicHeight(context, .03),
          onChanged: (value) {
            controllerName = value;
          },
          onFieldSubmitted: (value) {
            print(controllerName);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "This field is required";
            } else {
              return null;
            }
          },
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
