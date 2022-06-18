import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_star/Services/firebase_helper.dart';

import '../Routes/routes.dart';
import '../Utils/custom_toast.dart';

class TripProvider with ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var userID = FirebaseAuth.instance.currentUser?.uid;
  // var userID = 3543;
  bool loading = false;
  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  postTripData(context, picUpLat, piUpLong, dropLat, dropLong, fear, totalTime,
      totalPayment, totalDistance) {
    try {
      setLoading(true);
      firebaseFirestore.collection('trip').doc(userID).set({
        'userId': userID,
        'picUpLat': picUpLat,
        'piUpLong': piUpLong,
        'dropLat': dropLat,
        'dropLong': dropLong,
        'fear': fear,
        'totalTime': totalTime,
        'totalPayment': totalPayment,
        'totalDistance': totalDistance,
        'createAt': DateTime.now(),
      }).then((value) {
        setLoading(false);
        ToastUtils.showCustomToast(
            context, "Ride Completed Success", Colors.green);
        Navigator.pushReplacementNamed(context, Routes.enterMobileNumber);
      }).catchError((e) {
        print('e: $e');
        setLoading(false);
        ToastUtils.showCustomToast(
            context, "Ride Cancel! \n please try again later", Colors.red);
      });
    } catch (e) {
      print('e: $e');
      setLoading(false);
      ToastUtils.showCustomToast(
          context, "Ride Cancel! \n please try again later", Colors.red);
    }
  }
}
