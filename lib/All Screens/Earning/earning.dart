import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_star/Images/images.dart';

import '../../Custom Widgets/customWidgets.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  State<Earning> createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: CustomWidget.setAppBar(context, true, 'Earning', 0xff2B2B2B,
          FontWeight.w600, 'Encode Sans', 18.sp),
      body: Container(
        padding: EdgeInsets.only(left: 26.w, right: 26.w),
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(40.h),
            Container(
              height: 500.h,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h),
                children: [
                  singleContainerWidget(moneyblue, 'Today Earnings', '৳ 500'),
                  singleContainerWidget(routeblue, 'Today Trips', '8'),
                  singleContainerWidget(moneyreed, 'Total Earnings', '৳ 50000'),
                  singleContainerWidget(routegreen, 'Total Trips', '80'),
                  singleContainerWidget(totalduo, 'Total Due', '৳ 50000'),
                  singleContainerWidget(persant, 'Commision Rate', '100%'),
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
