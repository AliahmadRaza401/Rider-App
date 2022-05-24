import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_star/Services/firebase_helper.dart';

import '../Utils/custom_toast.dart';

class TripProvider with ChangeNotifier {
  String? drivercuradd;
  String? drivercurlat;
  String? drivercurlog;
  String? destinationcuradd;
  String? destinationcurlat;
  String? destinationcurlog;
  bool? drivertripfear;
  String? drivertripPrice;
  String? drivertripDistance;
  String? drivertripTime;

}
