import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_star/Services/firebase_helper.dart';

import '../Utils/custom_toast.dart';

class UserProfileProvider with ChangeNotifier {
  String? personalPicture;
  String? personalName;
  String? personalMobileNumber;
  String? personalVehicle;
  String? nidFrontImg;
  String? nidBackImg;
  String? nidCardNumber;
  String? drivingLicenseFrontImg;
  String? drivingLicenseBackImg;
  String? drivingLicenseNumber;
  String? drivingLicenseExpiryDate;
  String? enlistmentCertificateImage;
  String? enlistmentCertificateNumber;
  String? enlistmentCertificateExpiryDate;

  void postDetailsToFirestore(BuildContext context) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    String userPic =
        await FirebaseHelper.imageUpload(personalPicture, DateTime.now());
    print('userPic: $userPic');
    String nidFPic =
        await FirebaseHelper.imageUpload(nidFrontImg, DateTime.now());

    String nidBPic =
        await FirebaseHelper.imageUpload(nidBackImg, DateTime.now());
    String driveringLicFPick = await FirebaseHelper.imageUpload(
        drivingLicenseFrontImg, DateTime.now());
    String driveringLicBPick =
        await FirebaseHelper.imageUpload(drivingLicenseBackImg, DateTime.now());
    String enlistCertiPick = await FirebaseHelper.imageUpload(
        enlistmentCertificateImage, DateTime.now());

    await firebaseFirestore.collection("users").doc().set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'userPic': userPic.toString(),
      'userName': personalName,
      'userMobile': personalMobileNumber,
      'vehicleType': personalVehicle,
      'nidFPic': nidFPic,
      'nidBPic': nidBPic,
      'nidCardNo': nidCardNumber,
      'driveringLicFPick': driveringLicFPick,
      'driveringLicBPick': driveringLicBPick,
      'driveringLicNo': drivingLicenseNumber,
      'driveringLicExpDate': drivingLicenseExpiryDate,
      'enlistCertiPick': enlistCertiPick,
      'enlistCertiNo': enlistmentCertificateNumber,
      'enlistCertiExpDate': enlistmentCertificateExpiryDate,
      'createAt': DateTime.now(),
    }).then((value) {
      ToastUtils.showCustomToast(context, "SignUp Success", Colors.green);
    }).catchError((e) {
      ToastUtils.showCustomToast(
          context, "SignUp Fail! \n please try again later", Colors.red);
    });
  }
}
