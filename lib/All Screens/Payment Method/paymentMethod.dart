import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_star/Custom%20Widgets/customWidgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ride_star/Provider/tripProvider.dart';

import '../map/distace_calculate.dart';

class PaymentMethod extends StatefulWidget {
  double pickUpLat;
  double pickUpLong;
  double dropLat;
  double dropLong;
  bool ichecked;
  PaymentMethod(
      {Key? key,
      required this.pickUpLat,
      required this.pickUpLong,
      required this.dropLat,
      required this.dropLong,
      required this.ichecked})
      : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  late TripProvider tripProvider;
  late LatLng distination;
  int? checkedValue;
  @override
  void initState() {
    tripProvider = Provider.of<TripProvider>(context, listen: false);

    setState(() {
      distination = LatLng(widget.dropLat, widget.dropLong);
      checkedValue = widget.ichecked == true ? 20 : 0;
    });
    claculatePaymentandDistance();

    super.initState();
  }

  var distance, time, total;
  var ridedistance, rideTime;
  claculatePaymentandDistance() {
    ridedistance = calculateHarvesineDistanceInKM(
        LatLng(widget.pickUpLat, widget.dropLong), distination);
    rideTime = calculateETAInMinutes(ridedistance, 30);
    distance = ridedistance * 12.0;
    time = rideTime * 0.40;
    total = distance + time + checkedValue;
  }

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
              child: CustomWidget.textWidget('৳${total.toStringAsFixed(2)}',
                  'Encode Sans', 24.sp, FontWeight.w700, 0xff217D38),
            ),
            CustomWidget.heightSizedBoxWidget(25.h),
            const DottedLine(
              lineThickness: 2,
            ),
            CustomWidget.heightSizedBoxWidget(25.h),
            rowWidget('Base Fare', '', '৳ $checkedValue'),
            rowWidget(
                'Distance',
                '(${ridedistance.toStringAsFixed(2)} km × 12)',
                '৳ ${distance.toStringAsFixed(2)}'),
            CustomWidget.heightSizedBoxWidget(10.h),
            rowWidget('Duration', '(${rideTime.toStringAsFixed(2)} min ×0.40)',
                '৳ ${time.toStringAsFixed(2)}'),
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
                CustomWidget.textWidget('৳ ${total.toStringAsFixed(2)}',
                    'Encode Sans', 16.sp, FontWeight.w600, 0xff2b2b2b),
              ],
            ),
            CustomWidget.heightSizedBoxWidget(90.h),
            // CustomWidget.customButtonWithoutArrowWidget(
            //     context, '/enterMobileNumber2', 'Recieve Cash'),
            InkWell(
              onTap: () {
                tripProvider.postTripData(
                  context,
                  widget.pickUpLat,
                  widget.pickUpLong,
                  widget.dropLat,
                  widget.dropLong,
                  widget.ichecked,
                  time,
                  total,
                  ridedistance,
                );
              },
              child: Container(
                  height: 56.h,
                  width: 323.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
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
                        'Recieve Cash',
                        style: TextStyle(
                            color: const Color(0xffFFFFFF),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Encode Sans'),
                      ),
                    ],
                  )),
            ),
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
