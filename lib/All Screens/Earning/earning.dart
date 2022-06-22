import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_star/Images/images.dart';
import 'package:ride_star/Provider/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Custom Widgets/customWidgets.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  State<Earning> createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  var totalEarning = 0.0;
  var todayTrip = 0;
  var todayEarning = 0.0;
  var totalTrip = 0;
  var totalDuo = 0;
  var commissionRate = 0;

  @override
  void initState() {
    checkUserDetails();
    super.initState();
  }

  checkUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('uid');
    print('id: $id');

    final date2 = DateTime.now();
    print(date2);
    print('checkUser________________________________________!');
    FirebaseFirestore.instance.collection("trip").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print('1');
        final finaldate = doc['createAt'].toDate();
        print('2');
        //        var totalEarning = 0.0;
        // var todayTrip = 0;
        // var todayEarning = 0.0;
        // var totalTrip = 0;
        // var totalDuo = 0;
        // var commissionRate = 0;
        final difference = date2.difference(finaldate).inDays;
        print('difference  =  ' + difference.toString());
        print('docId = ' + doc['userId'].toString());

        if (doc['userId'].toString() == id.toString()) {
          print('id: $id');
          setState(() {
            totalEarning = totalEarning + doc['totalPayment'];
            print('todayEarning: $todayEarning');
            totalTrip = totalTrip + 1;
            print('todayTrip: $todayTrip');
          });

          if (difference <= 0) {
            setState(() {
              todayEarning = todayEarning + doc['totalPayment'];
              print('todayEarning: $todayEarning');
              todayTrip = todayTrip + 1;
              print('todayTrip: $todayTrip');
            });
          }
        }

        print('total Trip = ' + todayEarning.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffE5E5E5),
      backgroundColor:Colors.white,
      appBar: CustomWidget.setAppBar(context, true, 'Earning', 0xff2B2B2B,
          FontWeight.w600, 'Encode Sans', 18.sp),
      body: Container(
        padding: EdgeInsets.only(left: 26.w, right: 26.w),
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(40.h),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h),
                children: [
                  singleContainerWidget(
                      moneyblue, 'Today Earnings', totalEarning.toStringAsFixed(2)),
                  singleContainerWidget(
                      routeblue, 'Today Trips', todayTrip.toString()),
                  singleContainerWidget(
                      moneyreed, 'Total Earnings', totalEarning.toStringAsFixed(2)),
                  singleContainerWidget(
                      routegreen, 'Total Trips', totalTrip.toString()),
                  singleContainerWidget(
                      totalduo, 'Total Due', totalDuo.toString()),
                  singleContainerWidget(
                      persant, 'Commision Rate', commissionRate.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget singleContainerWidget(
    String img,
    String text1,
    String text2,
  ) {
    return Container(
      height: 196.h,
      width: 151.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: const Color(0xffFFFFFF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage(img),
            ),
          ),
          CustomWidget.heightSizedBoxWidget(10.h),
          CustomWidget.textWidget(
              text1, 'Encode Sans', 14.sp, FontWeight.w600, 0xff606060),
          CustomWidget.heightSizedBoxWidget(10.h),
          CustomWidget.textWidget(
              text2, 'Encode Sans', 16.sp, FontWeight.w600, 0xff2B2B2B),
        ],
      ),
    );
  }
}
