import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_star/All%20Screens/Login%20Folder/logIn.dart';
import 'package:ride_star/Routes/routes.dart';
import 'package:ride_star/Services/app_route.dart';
import 'package:ride_star/Services/firebase_helper.dart';
import 'package:ride_star/Services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../All Screens/Home/home.dart';
import '../Utils/custom_toast.dart';

class UserProfileProvider with ChangeNotifier {
  bool loading = false;

  var personalPicture;
  String? personalName;
  String? personalMobileNumber;
  String? personalVehicle;
  var nidFrontImg;
  var nidBackImg;
  String? nidCardNumber;
  var drivingLicenseFrontImg;
  var drivingLicenseBackImg;
  String? drivingLicenseNumber;
  String? drivingLicenseExpiryDate;
  var enlistmentCertificateImage;
  String? enlistmentCertificateNumber;
  String? enlistmentCertificateExpiryDate;

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }



  

  void postDetailsToFirestore(BuildContext context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setLoading(true);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      print('personalPicture: $personalPicture');
      print('nidFrontImg: $nidFrontImg');
      print('nidFrontImg: $nidFrontImg');
      print('nidBackImg: $nidBackImg');
      print('drivingLicenseFrontImg: $drivingLicenseFrontImg');
      print('drivingLicenseBackImg: $drivingLicenseBackImg');
      print('enlistmentCertificateImage: $enlistmentCertificateImage');

      String userPic = await FirebaseHelper.imageUpload(
          personalPicture, personalPicture.toString());
      print('userPic: $userPic');
      String nidFPic = await FirebaseHelper.imageUpload(
          nidFrontImg, DateTime.now().toString());

      String nidBPic = await FirebaseHelper.imageUpload(
          nidBackImg, DateTime.now().toString());
      String driveringLicFPick = await FirebaseHelper.imageUpload(
          drivingLicenseFrontImg, DateTime.now().toString());
      String driveringLicBPick = await FirebaseHelper.imageUpload(
          drivingLicenseBackImg, DateTime.now().toString());
      String enlistCertiPick = await FirebaseHelper.imageUpload(
          enlistmentCertificateImage, DateTime.now().toString());
      print("Image post Done________________________________");
      var uuid = Uuid().v1();

      await firebaseFirestore.collection("users").doc(uuid.toString()).set({
        'uid': uuid.toString(),
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
       
      }).then((value) {
        setLoading(false);
        ToastUtils.showCustomToast(context, "SignUp Success", Colors.green);
        // Navigator.pushReplacementNamed(context, Routes.enterMobileNumber);
        // AppRoutes.push(context, const LogInScreen());
            SharedPref.userLoggedIn(true);
          
        // SharedPref.saveUserId(FirebaseAuth.instance.currentUser!.uid.toString());
          // preferences.setString("uid", doc['uid']);
          // userExist = true;
          // userProvider.userModel = MyUserModel.fromMap(doc.data());
        AppRoutes.push(context, Home());
      }).catchError((e) {
        setLoading(false);
        ToastUtils.showCustomToast(
            context, "SignUp Fail! \n please try again later", Colors.red);
      });
    } catch (e) {
      print('e: $e');
      setLoading(false);
      ToastUtils.showCustomToast(
          context, "SignUp Fail! \n please try again later", Colors.red);
    }
  }
}
