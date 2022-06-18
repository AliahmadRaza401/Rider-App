import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_star/model/userModel.dart';

class UserProvider with ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  late MyUserModel userModel;

  Future getUserById(String uid) async {
    print('uid: $uid');
    var data;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      userModel = MyUserModel.fromMap(data);

      print('Userdata: $data');
    } else {
      print("users null");
    }

    return data;
  }
}
