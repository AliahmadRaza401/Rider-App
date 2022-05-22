import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:dotted_line/dotted_line.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.setAppBar(context, false, 'Payment Method',
          0xff2B2B2B, FontWeight.w600, 'Encode Sans', 18.sp),
      body: Container(
        padding: EdgeInsets.only(
          left: 26.w,
          right: 26.w,
        ),
        child: Column(
          children: [
            CustomWidget.heightSizedBoxWidget(40.h),
            Align(
              alignment: Alignment.center,
              child: CustomWidget.textWidget('Customer Pay', 'Encode Sans',
                  24.sp, FontWeight.w700, 0xff2B2B2B),
            ),
            CustomWidget.heightSizedBoxWidget(15.h),
            Align(
              alignment: Alignment.center,
              child: CustomWidget.textWidget(
                  '৳172', 'Encode Sans', 24.sp, FontWeight.w700, 0xff217D38),
            ),
            CustomWidget.heightSizedBoxWidget(25.h),
            const DottedLine(
              lineThickness: 2,
            ),
            CustomWidget.heightSizedBoxWidget(25.h),
            rowWidget('Base Fare', '', '৳ 25'),
            rowWidget('Distance', '(9 km × 11)', '৳ 132'),
            CustomWidget.heightSizedBoxWidget(10.h),
            rowWidget('Duration', '(20 min ×0.4)', '৳ 8'),
            CustomWidget.heightSizedBoxWidget(25.h),
            const DottedLine(
              lineThickness: 2,
            ),
            CustomWidget.heightSizedBoxWidget(25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidget.textWidget('Sub Total', 'Encode Sans', 16.sp,
                    FontWeight.w600, 0xffCE1A17),
                CustomWidget.textWidget(
                    '৳ 172', 'Encode Sans', 16.sp, FontWeight.w600, 0xff2b2b2b),
              ],
            ),
            CustomWidget.heightSizedBoxWidget(90.h),
             CustomWidget.customButtonWithoutArrowWidget(
                  context, '/enterMobileNumber2', 'Recieve Cash'),
          ],
        ),
      ),
    );
  }

  Widget rowWidget(
    String text1,
    String text2,
    String text3,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomWidget.textWidget(
                text1, 'Encode Sans', 16.sp, FontWeight.w400, 0xffCE1A17),
            CustomWidget.heightSizedBoxWidget(3.h),
            CustomWidget.textWidget(
                text2, 'Encode Sans', 14.sp, FontWeight.w400, 0xff2B2B2B),
          ],
        ),
        CustomWidget.textWidget(
            text3, 'Encode Sans', 16.sp, FontWeight.w400, 0xff2B2B2B),
      ],
    );
  }
}
